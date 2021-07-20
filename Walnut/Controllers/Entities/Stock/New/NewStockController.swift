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
    func makeController() -> NewStockController // TODO: Have every factory produce the associated type...
    func makeTableView() -> NewStockTableView
    func makeRouter() -> NewStockRouter
    func makeLeftItem(target: NewStockController) -> UIBarButtonItem
    func makeRightItem(target: NewStockController) -> UIBarButtonItem
}

class NewStockControllerContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream, router: NewStockRouter? = nil, tableView: NewStockTableView? = nil)
    {
        self.model = NewStockModel()
        self.context = context
        self.stream = stream
    }
}

extension NewStockControllerContainer: NewStockControllerFactory
{
    func makeController() -> NewStockController
    {
        return NewStockController(container: self)
    }
    
    func makeTableView() -> NewStockTableView
    {
        let container = NewStockTableViewContainer(
            newStockModel: model,
            stream: stream,
            style: .grouped)
        return .init(container: container)
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
    var router: NewStockRouter
    var tableView: NewStockTableView
    
    // MARK: - Initialization
    
    required init(container: NewStockControllerContainer)
    {
        self.router = container.makeRouter()
        self.tableView = container.makeTableView()
        super.init(container: container)
        router.delegate = self
        subscribe(to: container.stream)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "New Stock".localized
        
        navigationItem.leftBarButtonItem = container.makeLeftItem(target: self)
        navigationItem.rightBarButtonItem = container.makeRightItem(target: self)
        
        view.embed(tableView)
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
        router.routeDismiss()
    }
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        router.routeToNext()
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
            router.routeToUnitSearch()
        case .valueType(let type):
            container.model.stockType = type
            tableView.reload(shouldReloadTableView: false)
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
            tableView.endUpdates()
        default:
            break
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard case .newStock = message.origin else { return }
        guard let unit = message.link as? Unit else { fatalError() }
        container.model.unit = unit
        tableView.shouldReload = true
        router.routeBack()
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
        
        tableView.shouldReload = true
    }
}
