//
//  SystemDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class SystemDetailRouterContainer: DependencyContainer
{
    // MARK: - Variables
    
    var system: System
    var stream: Stream
    
    // MARK: - Initialization
    
    init(system: System, stream: Stream)
    {
        self.system = system
        self.stream = stream
    }
}

class SystemDetailRouter: Router<SystemDetailRouterContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: SystemDetailRouterContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    func routeTostockDetail(stock: Stock)
    {
        delegate?.navigationController?.pushViewController(stock.detailController(), animated: true)
    }
    
    func routeToTransferFlowDetail(flow: TransferFlow)
    {
        delegate?.navigationController?.pushViewController(flow.detailController(), animated: true)
    }
    
    func routeToProcessFlowDetail(flow: ProcessFlow)
    {
        delegate?.navigationController?.pushViewController(flow.detailController(), animated: true)
    }
    
    func routeToEventDetail(event: Event)
    {
        delegate?.navigationController?.pushViewController(event.detailController(), animated: true)
    }
    
    func routeToNoteDetail(note: Note)
    {
        delegate?.navigationController?.pushViewController(note.detailController(), animated: true)
    }
}

extension SystemDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as SystemDetailTableViewSelectedMessage:
            handle(m)
        default:
            break
        }
    }
    
    // TODO: Not great with the section indexes
    func handle(_ message: SystemDetailTableViewSelectedMessage)
    {
        let indexPath = message.indexPath
        
        switch indexPath.section
        {
        case 1: // Stocks
            let stock = container.system.unwrappedStocks[indexPath.row]
            routeTostockDetail(stock: stock)
        case 2: // Flows
            let flow = container.system.unwrappedFlows[indexPath.row]
            
            if let flow = flow as? TransferFlow
            {
                routeToTransferFlowDetail(flow: flow)
            }
            else if let flow = flow as? ProcessFlow
            {
                routeToProcessFlowDetail(flow: flow)
            }
            else
            {
                fatalError("Cannot use an abstract Flow")
            }
        case 3: // Events
            let event = container.system.unwrappedEvents[indexPath.row]
            routeToEventDetail(event: event)
        case 4: // Notes
            let note = container.system.unwrappedNotes[indexPath.row]
            routeToNoteDetail(note: note)
        default:
            assertionFailure("Section doesn't exist")
            break
        }
    }
}
