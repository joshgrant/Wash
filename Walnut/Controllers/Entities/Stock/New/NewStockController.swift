//
//  NewStockController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

protocol NewStockControllerFactory: Factory
{
    func makeTableView() -> NewStockTableView
    func makeRouter() -> NewStockRouter
    func makeLeftItem() -> UIBarButtonItem
    func makeRightItem() -> UIBarButtonItem
}

class NewStockControllerContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var router: NewStockRouter
    var tableView: NewStockTableView
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(router: NewStockRouter, tableView: NewStockTableView, context: Context, stream: Stream)
    {
        self.model = NewStockModel()
        self.router = makeRouter()
        self.tableView = makeTableView()
        self.context = context
        self.stream = stream
    }
}

extension NewStockControllerContainer: NewStockControllerFactory
{
    func makeTableView() -> NewStockTableView
    {
        return NewStockTableView(newStockModel: model)
    }
    
    func makeRouter() -> NewStockRouter
    {
        let container = NewStockRouterContainer(
            model: model,
            context: context,
            stream: stream)
        return NewStockRouter(container: container)
    }
    
    // TODO: For all of these buttons, use a responder instead
    // of passing the controller... The router should conform
    // to a protocol that handles the methods...
     
    func makeLeftItem(target: NewStockController) -> UIBarButtonItem
    {
        let leftItem = UIBarButtonItem(systemItem: .cancel)
        leftItem.target = target
        leftItem.action = #selector(target.leftBarButtonItemDidTouchUpInside(_:))
        return leftItem
    }
    
    func makeRightItem(target: NewStockController) -> UIBarButtonItem
    {
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: target,
            action: #selector(target.rightBarButtonItemDidTouchUpInside(_:)))
        return rightItem
    }
}

class NewStockController: ViewController<NewStockControllerContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: NewStockControllerContainer)
    {
        super.init(container: container)
        container.router.delegate = self
        subscribe(to: container.stream)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "New Stock".localized
        
        navigationItem.leftBarButtonItem = container.makeLeftItem(target: self)
        navigationItem.rightBarButtonItem = container.makeRightItem(target: self)
        
        view.embed(container.tableView)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: Interface outlets
    
    @objc func leftBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        container.router.routeDismiss()
    }
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        container.router.routeToNext()
    }
}

extension NewStockController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        case let m as TextEditCellMessage:
            handle(m)
        case let m as ToggleCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .newStockUnit:
            container.router.routeToUnitSearch()
        case .valueType(let type):
            container.model.stockType = type
            container.tableView.reload(shouldReloadTableView: false)
            container.tableView.beginUpdates()
            container.tableView.reloadSections(IndexSet(integer: 2), with: .none)
            container.tableView.endUpdates()
        default:
            break
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard case .newStock = message.origin else { return }
        guard let unit = message.link as? Unit else { fatalError() }
        container.newStockModel.unit = unit
        container.tableView.shouldReload = true
        container.router.routeBack()
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        guard case .newStockName = message.selectionIdentifier else { return }
        container.model.title = message.title
    }
    
    private func handle(_ message: ToggleCellMessage)
    {
        guard case .stateMachine = message.selectionIdentifier else { return }
        container.model.isStateMachine = message.state
        
        if container.model.isStateMachine
        {
            if container.model.stockType == .boolean
            {
                container.model.stockType = .decimal
            }
        }
        else if container.model.previouslyBoolean
        {
            container.model.stockType = .boolean
        }
        
        container.tableView.shouldReload = true
    }
}
