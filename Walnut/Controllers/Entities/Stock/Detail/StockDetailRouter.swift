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
        case inflow(flow: TransferFlow)
        case outflow(flow: TransferFlow)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    var stock: Stock
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        subscribe(to: AppDelegate.shared.mainStream)
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
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
        case .inflow(let flow):
            routeToInflow(flow: flow)
        case .outflow(let flow):
            routeToOutFlow(flow: flow)
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
    
    private func routeToInflow(flow: TransferFlow)
    {
        let controller = flow.detailController()
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func routeToOutFlow(flow: TransferFlow)
    {
        let controller = flow.detailController()
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
        guard let _ = message.tableView as? StockDetailTableView else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .type:
            route(to: .valueType, completion: nil)
        case .dimension:
            route(to: .dimension, completion: nil)
        case .inflow(let flow):
            route(to: .inflow(flow: flow), completion: nil)
        case .outflow(let flow):
            route(to: .outflow(flow: flow), completion: nil)
        default:
            return
        }
    }
}
