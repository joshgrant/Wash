//
//  StockDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class StockDetailRouterContainer: DependencyContainer
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

class StockDetailRouter: Router<StockDetailRouterContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: StockDetailRouterContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    func routeToValueType()
    {
        let container = StockValueTypeContainer(stock: container.stock, stream: container.stream)
        let controller = container.makeController()
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func routeToIdeal()
    {
        let container = IdealDetailContainer(stock: container.stock, stream: container.stream)
        let controller = container.makeController()
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func routeToCurrent()
    {
        let container = CurrentDetailContainer(stock: container.stock, stream: container.stream)
        let controller = container.makeController()
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func routeToInflow(flow: TransferFlow)
    {
        let controller = flow.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func routeToOutFlow(flow: TransferFlow)
    {
        let controller = flow.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension StockDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        guard let _ = message.tableView as? TableView<StockDetailTableViewContainer> else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .type:
            routeToValueType()
        case .inflow(let flow):
            routeToInflow(flow: flow)
        case .outflow(let flow):
            routeToOutFlow(flow: flow)
        default:
            return
        }
    }
}
