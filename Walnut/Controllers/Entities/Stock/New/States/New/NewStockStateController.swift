//
//  NewStockStateController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class NewStockStateController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var newStockModel: NewStockModel
    var tableView: NewStockStateTableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, context: Context?)
    {
        self.newStockModel = newStockModel
        self.context = context
        
        tableView = NewStockStateTableView(newStockModel: newStockModel)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = "States".localized
        
        view.embed(tableView)
        
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemDidTouchUpInside(_:)))
        rightItem.isEnabled = newStockModel.validForStates
        
        navigationItem.rightBarButtonItem = rightItem
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillChangeFrame(_:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: Interface outlets
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        let currentIdealController = CurrentIdealController(
            newStockModel: newStockModel,
            context: context)
        navigationController?.pushViewController(currentIdealController, animated: true)
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
            newStockModel.states.append(newState)
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
            tableView.insertSections(IndexSet(integer: newStockModel.states.count), with: .automatic)
            tableView.endUpdates()
            
            navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForStates
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
        
        navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForStates
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
        
        navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForStates
    }
}
