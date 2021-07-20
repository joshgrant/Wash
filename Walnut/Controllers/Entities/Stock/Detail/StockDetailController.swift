//
//  StockDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

protocol StockDetailFactory: Factory
{
    func makeStockDetailRouter() -> StockDetailRouter
    func makeTableView() -> TableView<StockDetailTableViewContainer>
    func makePinNavigationItem() -> BarButtonItem
}

class StockDetailContainer: DependencyContainer
{
    // MARK: - Defined types
    
    typealias Table = TableView<StockDetailTableViewContainer>
    
    // MARK: - Variables
    
    var stock: Stock
    var stream: Stream
    var router: StockDetailRouter
    var tableView: Table
    
    // MARK: - Initialization
    
    init(stock: Stock, stream: Stream, router: StockDetailRouter? = nil, tableView: Table? = nil)
    {
        self.stock = stock
        self.stream = stream
        self.router = router ?? makeStockDetailRouter()
        self.tableView = tableView ?? makeTableView()
    }
}

extension StockDetailContainer: StockDetailFactory
{
    func makeStockDetailRouter() -> StockDetailRouter
    {
        let container = StockDetailRouterContainer(
            stock: stock,
            stream: stream)
        return StockDetailRouter(container: container)
    }
    
    func makeTableView() -> Table
    {
        let container = StockDetailTableViewContainer(
            stock: stock,
            stream: stream,
            style: .grouped)
        return Table(container: container)
    }
    
    func makePinNavigationItem() -> BarButtonItem
    {
        let icon: Icon = stock.isPinned ? .pinFill : .pin
        
        let actionClosure = ActionClosure { sender in
            stock.isPinned.toggle()
            let message = EntityPinnedMessage(
                isPinned: stock.isPinned,
                entity: stock)
            AppDelegate.shared.mainStream.send(message: message)
        }
        
        return BarButtonItem(
            image: icon.getImage(),
            style: .plain,
            actionClosure: actionClosure)
    }
}

class StockDetailController: ViewController<StockDetailContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    required init(container: StockDetailContainer)
    {
        self.pinBarButtonItem = container.makePinNavigationItem()
        
        super.init(container: container)
        container.router.delegate = self
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
        title = container.stock.title
        view.embed(container.tableView)
        navigationItem.setRightBarButtonItems([pinBarButtonItem], animated: false)
    }
}

extension StockDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TextEditCellMessage:
            handle(m)
        case let m as EntityPinnedMessage:
            handle(m)
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        // TODO: Make sure the message is stock and not stockFrom/stockTo
        guard case .stock(let s) = message.selectionIdentifier, s == container.stock else { return }
        
        switch message.selectionIdentifier
        {
        // TODO: Unwrap the type of ideal and current `.ideal(let type):` and use
        // it to do Double/Bool/Int
        case .ideal:
            guard let content = Double(message.title) else { fatalError() }
            container.stock.idealValue = content
            container.tableView.shouldReload = true
        case .current:
            guard let content = Double(message.title) else { fatalError() }
            container.stock.amountValue = content
            container.tableView.shouldReload = true
        case .title:
            title = message.title
            container.stock.title = message.title
        default:
            break
        }
        
        container.stock.managedObjectContext?.quickSave()
    }
    
    // TODO: The same as the system detail
    private func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == container.stock else { return }
        
        let pinned = message.isPinned
        let icon: Icon = pinned ? .pinFill : .pin
        
        pinBarButtonItem.image = icon.getImage()
        container.stock.isPinned = pinned
        container.stock.managedObjectContext?.quickSave()
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .ideal:
            container.router.route(to: .ideal, completion: nil)
        case .current:
            container.router.route(to: .current, completion: nil)
        case .valueType, .transitionType:
            container.tableView.shouldReload = true
        default:
            break
        }
    }
}
