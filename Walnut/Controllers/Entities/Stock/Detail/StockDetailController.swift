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
    func makeController() -> StockDetailController
    func makePinNavigationItem() -> BarButtonItem
    func makeStockDetailRouter() -> StockDetailRouter
    func makeTableView() -> TableView<StockDetailTableViewContainer>
}

class StockDetailContainer: Container
{
    // MARK: - Variables
    
    var stock: Stock
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(stock: Stock, context: Context, stream: Stream)
    {
        self.stock = stock
        self.context = context
        self.stream = stream
    }
}

extension StockDetailContainer: StockDetailFactory
{
    func makeController() -> StockDetailController
    {
        .init(container: self)
    }
    
    func makePinNavigationItem() -> BarButtonItem
    {
        let icon: Icon = stock.isPinned ? .pinFill : .pin
        
        let actionClosure = ActionClosure { [unowned self] sender in
            self.stock.isPinned.toggle()
            let message = EntityPinnedMessage(
                isPinned: self.stock.isPinned,
                entity: self.stock)
            self.stream.send(message: message)
        }
        
        return BarButtonItem(
            image: icon.getImage(),
            style: .plain,
            actionClosure: actionClosure)
    }
    
    func makeStockDetailRouter() -> StockDetailRouter
    {
        let container = StockDetailRouterContainer(
            stock: stock,
            context: context,
            stream: stream)
        return StockDetailRouter(container: container)
    }
    
    func makeTableView() -> TableView<StockDetailTableViewContainer>
    {
        let container = StockDetailTableViewContainer(
            stock: stock,
            stream: stream,
            style: .grouped)
        return .init(container: container)
    }
}

class StockDetailController: ViewController<StockDetailContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var router: StockDetailRouter
    var tableView: TableView<StockDetailTableViewContainer>
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    required init(container: StockDetailContainer)
    {
        router = container.makeStockDetailRouter()
        tableView = container.makeTableView()
        pinBarButtonItem = container.makePinNavigationItem()
        
        super.init(container: container)
        router.delegate = self
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
        view.embed(tableView)
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
            tableView.shouldReload = true
        case .current:
            guard let content = Double(message.title) else { fatalError() }
            container.stock.amountValue = content
            tableView.shouldReload = true
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
            router.routeToIdeal()
        case .current:
            router.routeToCurrent()
        case .valueType, .transitionType:
            tableView.shouldReload = true
        default:
            break
        }
    }
}
