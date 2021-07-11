//
//  TransferFlowDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case stockFrom
        case stockTo
        case eventDetail(event: Event)
        case historyDetail(history: History)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var flow: TransferFlow
    
    weak var delegate: RouterDelegate?
    weak var context: Context?
    
    weak var _stream: Stream?
    var stream: Stream { return _stream ?? AppDelegate.shared.mainStream }
    
    var presentedDestination: Destination?
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, context: Context?, _stream: Stream? = nil)
    {
        self.flow = flow
        
        self._stream = _stream
        self.context = context
        subscribe(to: stream)
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .stockTo:
            routeToStockTo()
        case .stockFrom:
            routeToStockFrom()
        case .eventDetail(let event):
            routeToEventDetail(event)
        case .historyDetail(let history):
            routeToHistoryDetail(history)
        }
    }
    
    private func routeToStockFrom()
    {
        let searchController = LinkSearchController(
            origin: .stockFrom,
            entity: flow,
            entityType: Stock.self,
            context: context,
            _stream: stream)
        let navigationController = UINavigationController(rootViewController: searchController)
        presentedDestination = .stockFrom
        delegate?.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    private func routeToStockTo()
    {
        let searchController = LinkSearchController(
            origin: .stockTo,
            entity: flow,
            entityType: Stock.self,
            context: context,
            _stream: stream)
        let navigationController = UINavigationController(rootViewController: searchController)
        presentedDestination = .stockTo
        delegate?.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    private func routeToEventDetail(_ event: Event)
    {
        let detail = event.detailController()
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    private func routeToHistoryDetail(_ history: History)
    {
        let detail = history.detailController()
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
}

extension TransferFlowDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handleTableViewSelectionMessage(m)
        default:
            break
        }
    }
    
    private func handleTableViewSelectionMessage(_ message: TableViewSelectionMessage)
    {
        guard let _ = message.tableView as? TransferFlowDetailTableView else { return }
        
        // TODO: `fromStock` and `toStock` shouldn't Necessarily open up the link
        // screen. Rather, we should have a link button for each of the cells
        
        switch message.cellModel.selectionIdentifier
        {
        case .fromStock:
            route(to: .stockFrom, completion: nil)
        case .toStock:
            route(to: .stockTo, completion: nil)
        case .flowAmount:
            break
        case .flowDuration:
            break
        case .event(let event):
            route(to: .eventDetail(event: event), completion: nil)
        case .history(let history):
            route(to: .historyDetail(history: history), completion: nil)
        default:
            break
        }
    }
}
