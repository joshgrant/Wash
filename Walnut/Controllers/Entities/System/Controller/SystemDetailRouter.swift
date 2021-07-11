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
        // If the entity is nil, we're trying to create one
        case idealInfo
        case stockDetail(stock: Stock?)
        case flowDetail(flow: Flow?)
        case eventDetail(event: Event?)
        case subsystemDetail(system: System?)
        case noteDetail(note: Note?)
        
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
    
    // MARK: - Functions
    
    func route(
        to destination: Destination,
        completion: (() -> Void)?)
    {
        switch destination
        {
        case .stockDetail(let stock):
            guard let stockDetail = stock?.detailController() else
            {
                assertionFailure()
                return
            }
            delegate?.navigationController?.pushViewController(stockDetail, animated: true)
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
        case let x as SystemDetailTableViewSelectedMessage:
            handle(message: x)
        default:
            break
        }
    }
    
    func handle(message: SystemDetailTableViewSelectedMessage)
    {
        let indexPath = message.indexPath
        
        switch indexPath.section
        {
        case 1: // Stocks
            let stock = system.unwrappedStocks[indexPath.row]
            return route(to: .stockDetail(stock: stock), completion: nil)
        case 2: // Flows
            let flow = system.unwrappedFlows[indexPath.row]
            return route(to: .flowDetail(flow: flow), completion: nil)
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
