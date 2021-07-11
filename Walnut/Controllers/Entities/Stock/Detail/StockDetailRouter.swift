//
//  StockDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class StockDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case valueType
        case dimension
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var stock: Stock
    var root: UINavigationController?
    
    // MARK: - Initialization
    
    init(stock: Stock, root: UINavigationController?)
    {
        self.stock = stock
        self.root = root
        subscribe(to: StockDetailController.stream)
    }
    
    // MARK: - Functions
    
    func route(
        to destination: Destination,
        completion: (() -> Void)?)
    {
        switch destination
        {
        case .valueType:
            routeToValueType()
        case .dimension:
            routeToDimension()
        }
    }
    
    private func routeToValueType()
    {
        let controller = StockValueTypeController(stock: stock)
        root?.pushViewController(controller, animated: true)
    }
    
    private func routeToDimension()
    {
        
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
        guard message.token == .stockDetail else { return }
        
        switch (message.indexPath.section, message.indexPath.row)
        {
        case (0, 1): // Value type
            route(to: .valueType, completion: nil)
        case (0, 2): // Dimension
            route(to: .dimension, completion: nil)
        default:
            assertionFailure("Unhandled cell selection")
            return
        }
    }
}
