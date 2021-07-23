//
//  SystemDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

protocol SystemDetailFactory: Factory
{
    func makeController() -> SystemDetailController
    
    func makeResponder() -> SystemDetailResponder
    func makeRouter() -> SystemDetailRouter
    func makeTableView() -> SystemDetailTableView
    
    func makeDuplicateNavigationItem(responder: SystemDetailResponder) -> UIBarButtonItem
    func makePinNavigationItem(responder: SystemDetailResponder) -> UIBarButtonItem
}

class SystemDetailContainer: Container
{
    // MARK: - Variables
    
    var system: System
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(system: System, context: Context, stream: Stream)
    {
        self.system = system
        self.context = context
        self.stream = stream
    }
}

extension SystemDetailContainer: SystemDetailFactory
{
    func makeController() -> SystemDetailController
    {
        .init(container: self)
    }
    
    func makeResponder() -> SystemDetailResponder
    {
        let container = SystemDetailResponderContainer(system: system, stream: stream)
        return container.makeResponder()
    }
    
    func makeRouter() -> SystemDetailRouter
    {
        let container = SystemDetailRouterContainer(
            system: system,
            context: context,
            stream: stream)
        return container.makeRouter()
    }
    
    func makeTableView() -> SystemDetailTableView
    {
        let container = SystemDetailTableViewContainer(
            system: system,
            stream: stream,
            style: .grouped)
        return container.makeTableView()
    }
    
    // TODO: Responder should be a protocol...
    
    func makeDuplicateNavigationItem(responder: SystemDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.image,
            style: .plain,
            target: responder,
            action: #selector(responder.userTouchedUpInsideDuplicate(sender:)))
    }
    
    func makePinNavigationItem(responder: SystemDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: system.isPinned
                ? Icon.pinFill.image
                : Icon.pin.image,
            style: .plain,
            target: responder,
            action: #selector(responder.userTouchedUpInsidePin(sender:)))
    }
}

class SystemDetailController: ViewController<SystemDetailContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var router: SystemDetailRouter
    var responder: SystemDetailResponder
    var tableView: SystemDetailTableView
    var duplicateBarButtonItem: UIBarButtonItem
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    required init(container: SystemDetailContainer)
    {
        let router = container.makeRouter()
        let responder = container.makeResponder()
        
        self.router = router
        self.responder = responder
        self.tableView = container.makeTableView()
        self.duplicateBarButtonItem = container.makeDuplicateNavigationItem(responder: responder)
        self.pinBarButtonItem = container.makePinNavigationItem(responder: responder)
        
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.embed(tableView)
        configureNavigationItem(cellContent: container.system.title)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableView.makeTextCellFirstResponderIfEmpty()
    }
    
    func configureNavigationItem(cellContent: String)
    {
        if container.system.title.isEmpty
        {
            let actionClosure = ActionClosure { [unowned self] sender in
                let message = CancelCreationMessage(entity: self.container.system)
                self.container.stream.send(message: message)
            }
            
            // TODO: When to cancel, and when to delete?
            
            let cancelItem = BarButtonItem(title: "Cancel".localized, actionClosure: actionClosure)
            navigationItem.setLeftBarButton(cancelItem, animated: true)
            navigationItem.setRightBarButton(nil, animated: true)
        }
        else if cellContent.isEmpty
        {
            let actionClosure = ActionClosure { [unowned self] sender in
                let message = CancelCreationMessage(entity: self.container.system)
                self.container.stream.send(message: message)
            }
            
            // TODO: When to cancel, and when to delete?
            
            let cancelItem = BarButtonItem(title: "Delete".localized, actionClosure: actionClosure)
            navigationItem.setLeftBarButton(cancelItem, animated: true)
            navigationItem.setRightBarButtonItems(nil, animated: true)
        }
        else
        {
            title = container.system.title
            
            navigationItem.setLeftBarButton(nil, animated: true)
            navigationItem.setRightBarButtonItems([duplicateBarButtonItem, pinBarButtonItem], animated: true)
        }
    }
}

extension SystemDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as EntityPinnedMessage:
            handle(m)
        case let m as TextEditCellMessage:
            handle(m)
        case let m as SectionHeaderAddMessage:
            handle(m)
        case let m as SectionHeaderSearchMessage:
            handle(m)
        case let m as CancelCreationMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    func handle(_ message: TextEditCellMessage)
    {
        defer
        {
            configureNavigationItem(cellContent: message.title)
        }
        
        // Interesting business rule... don't handle changes if it's empty?
        if message.title.isEmpty { return }
        
        if case .system(let s) = message.selectionIdentifier, s == container.system
        {
            container.system.title = message.title
            container.system.managedObjectContext?.quickSave()
        }
        else
        {
            tableView.shouldReload = true
        }
    }
    
    func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == container.system else { return }
        
        let pinned = message.isPinned
        
        pinBarButtonItem.image = pinned
            ? Icon.pinFill.image
            : Icon.pin.image
        
        container.system.isPinned = pinned
        container.system.managedObjectContext?.quickSave()
    }
    
    private func handle(_ message: SectionHeaderAddMessage)
    {
        guard message.entityToAddTo == container.system else { return }
        
        let entity = message.entityType.init(context: container.context)
        
        switch entity
        {
        case let s as Stock:
            container.system.addToStocks(s)
            router.routeTostockDetail(stock: s)
        case let f as Flow:
            container.system.addToFlows(f)
            router.routeToFlowDetail(flow: f)
//        case let e as Event:
//            container.system.addToEvents(e)
//            router.routeToEventDetail(event: e)
        case let n as Note:
            container.system.addToNotes(n)
            router.routeToNoteDetail(note: n)
        default:
            break
        }
    }
    
    private func handle(_ message: SectionHeaderSearchMessage)
    {
        let container = LinkSearchControllerContainer(
            context: container.context,
            stream: container.stream,
            origin: .systemStockSearch,
            hasAddButton: false,
            entityType: message.typeToSearch)
        let controller = container.makeController()
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func handle(_ message: CancelCreationMessage)
    {
        let context = message.entity.managedObjectContext
        context?.delete(message.entity)
        context?.quickSave()
        
        navigationController?.popViewController(animated: true)
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        if case .systemStockSearch = message.origin
        {
            let link = message.link as! Stock
            container.system.addToStocks(link)
            container.system.managedObjectContext?.quickSave()
            tableView.shouldReload = true
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        guard message.tableView == tableView else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .stock(let stock):
            router.routeTostockDetail(stock: stock)
        default:
            break
        }
    }
}
