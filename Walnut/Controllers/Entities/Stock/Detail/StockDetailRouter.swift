//
//  StockDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

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
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
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
        delegate?.navigationController?.pushViewController(controller, animated: true)
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
        guard let _ = message.tableView as? StockDetailTableView else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .valueType:
            route(to: .valueType, completion: nil)
        case .dimension:
            route(to: .dimension, completion: nil)
        default:
            assertionFailure("Unhandled cell selection")
            return
        }
    }
}
