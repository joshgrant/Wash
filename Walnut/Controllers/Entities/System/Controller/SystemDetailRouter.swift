//
//  SystemDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class SystemDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case idealInfo
        case stockDetail(stock: Stock)
        case transferFlowDetail(flow: TransferFlow)
        case processFlowDetail(flow: ProcessFlow)
        case eventDetail(event: Event)
        case subsystemDetail(system: System)
        case noteDetail(note: Note)
        
        case search(entityType: Entity.Type)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var system: System
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(system: System)
    {
        self.system = system
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
        case .stockDetail(let stock):
            delegate?.navigationController?.pushViewController(stock.detailController(), animated: true, completion: completion)
        case .transferFlowDetail(let flow):
            delegate?.navigationController?.pushViewController(flow.detailController(), animated: true, completion: completion)
        case .processFlowDetail(let flow):
            delegate?.navigationController?.pushViewController(flow.detailController(), animated: true, completion: completion)
        case .eventDetail(let event):
            delegate?.navigationController?.pushViewController(event.detailController(), animated: true, completion: completion)
        case .noteDetail(let note):
            delegate?.navigationController?.pushViewController(note.detailController(), animated: true, completion: completion)
        default:
            assertionFailure()
            break
        }
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
    
    func handle(_ message: SystemDetailTableViewSelectedMessage)
    {
        let indexPath = message.indexPath
        
        switch indexPath.section
        {
        case 1: // Stocks
            let stock = system.unwrappedStocks[indexPath.row]
            return route(to: .stockDetail(stock: stock), completion: nil)
        case 2: // Flows
            let flow = system.unwrappedFlows[indexPath.row]
            
            if let flow = flow as? TransferFlow
            {
                return route(to: .transferFlowDetail(flow: flow), completion: nil)
            }
            else if let flow = flow as? ProcessFlow
            {
                return route(to: .processFlowDetail(flow: flow), completion: nil)
            }
            else
            {
                fatalError("Cannot use an abstract Flow")
            }
        case 3: // Events
            let event = system.unwrappedEvents[indexPath.row]
            return route(to: .eventDetail(event: event), completion: nil)
        case 4: // Notes
            let note = system.unwrappedNotes[indexPath.row]
            return route(to: .noteDetail(note: note), completion: nil)
        default:
            assertionFailure("Section doesn't exist")
            break
        }
    }
}
