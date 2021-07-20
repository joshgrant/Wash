//
//  TransferFlowDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailRouterContainer: DependencyContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var context: Context
    
    // MARK: - Initialization
    
    init(stream: Stream, context: Context)
    {
        self.stream = stream
        self.context = context
    }
}

class TransferFlowDetailRouter: Router<TransferFlowDetailRouterContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: TransferFlowDetailRouterContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions

    func routeToStockFrom()
    {
        let container = LinkSearchControllerContainer(
            context: container.context,
            stream: container.stream,
            origin: .stockFrom,
            hasAddButton: false,
            entityType: Stock.self)
        let controller = container.makeController()
        let navigationController = UINavigationController(rootViewController: controller)
        delegate?.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    func routeToStockTo()
    {
        let container = LinkSearchControllerContainer(
            context: container.context,
            stream: container.stream,
            origin: .stockTo,
            hasAddButton: false,
            entityType: Stock.self)
        let controller = container.makeController()
        let navigationController = UINavigationController(rootViewController: controller)
        delegate?.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    func routeToEventDetail(_ event: Event)
    {
        let detail = event.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToHistoryDetail(_ history: History)
    {
        let detail = history.detailController(context: container.context, stream: container.stream)
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
        guard let _ = message.tableView as? TableView<TransferFlowDetailTableViewContainer> else { return }
        
        // TODO: `fromStock` and `toStock` shouldn't Necessarily open up the link
        // screen. Rather, we should have a link button for each of the cells
        
        switch message.cellModel.selectionIdentifier
        {
        case .fromStock:
            routeToStockFrom()
        case .toStock:
            routeToStockTo()
        case .flowAmount:
            break
        case .flowDuration:
            break
        case .event(let event):
            routeToEventDetail(event)
        case .history(let history):
            routeToHistoryDetail(history)
        default:
            break
        }
    }
}
