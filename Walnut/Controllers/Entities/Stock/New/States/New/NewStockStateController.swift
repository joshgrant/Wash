//
//  NewStockStateController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol NewStockStateFactory: Factory
{
    func makeTableView() -> NewStockStateTableView
    func makeRightBarButtonItem(target: NewStockStateController) -> UIBarButtonItem
}

class NewStockStateContainer: Container
{
    // MARK: - Variables
    
    var model: NewStockModel
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(model: NewStockModel, context: Context, stream: Stream)
    {
        self.model = model
        self.context = context
        self.stream = stream
    }
}

extension NewStockStateContainer: NewStockStateFactory
{
    func makeTableView() -> NewStockStateTableView
    {
        let container = NewStockStateTableViewContainer(
            newStockModel: model,
            stream: stream,
            style: .grouped)
        return .init(container: container)
    }
    
    func makeRightBarButtonItem(target: NewStockStateController) -> UIBarButtonItem
    {
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: target,
            action: #selector(target.rightBarButtonItemDidTouchUpInside(_:)))
        rightItem.isEnabled = model.validForStates
        return rightItem
    }
}

class NewStockStateController: ViewController<NewStockStateContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    var tableView: NewStockStateTableView
    
    // MARK: - Initialization
    
    required init(container: NewStockStateContainer)
    {
        self.tableView = container.makeTableView()
        super.init(container: container)
        subscribe(to: container.stream)
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillChangeFrame(_:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "States".localized
        
        navigationItem.rightBarButtonItem = container.makeRightBarButtonItem(target: self)
        view.embed(tableView)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: Interface outlets
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        let container = CurrentIdealControllerContainer(
            model: container.model,
            context: container.context,
            stream: container.stream)
        let controller = container.makeController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification)
    {
        let frame = view.convert(notification.keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(frame)
        
        UIView.animate(
            withDuration: notification.animationDuration,
            delay: 0,
            options: notification.animationOptions,
            animations: {
                self.additionalSafeAreaInsets.bottom = intersection.height
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

extension NewStockStateController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handle(m)
        case let m as RightEditCellMessage:
            handle(m)
        case let m as TextEditCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .addState:
            // Add a state
            let newState = NewStateModel()
            container.model.states.append(newState)
            tableView.addState(newStateModel: newState)
            // TODO: Flawless table view updates / reloading with
            // cell models that match cells as well as text fields in the cells...
            
            // TODO: Deleting cells
            // TODO: Rearranging cells...
            
            // This is fragile because it will detach visible cells from models that
            // need to be attached...
            // So we're creating a hack that adds a state directly to the
            // table view model....
            //            tableView.reload(shouldReloadTableView: false)
            
            tableView.beginUpdates()
            tableView.insertSections(IndexSet(integer: container.model.states.count), with: .automatic)
            tableView.endUpdates()
            
            navigationItem.rightBarButtonItem?.isEnabled = container.model.validForStates
        default:
            break
        }
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        guard message.editType == .dismiss else { return }
        
        switch message.selectionIdentifier
        {
        case .stateFrom(let state):
            if message.content == "∞"
            {
                state.from = Double.infinity
            }
            else if message.content == "-∞"
            {
                state.from = -Double.infinity
            }
            else
            {
                state.from = Double(message.content) // TODO: Better conversions here
            }
        case .stateTo(let state):
            if message.content == "∞"
            {
                state.to = Double.infinity
            }
            else if message.content == "-∞"
            {
                state.to = -Double.infinity
            }
            else
            {
                state.to = Double(message.content) // TODO: Better conversions here
            }
        default:
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = container.model.validForStates
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        // TODO: Have to update the currently editing state
        
        switch message.selectionIdentifier
        {
        case .stateTitle(let state):
            state.title = message.title
        default:
            break
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = container.model.validForStates
    }
}
