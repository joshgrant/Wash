//
//  SystemDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

protocol SystemDetailRouterFactory: Factory
{
    func makeRouter() -> SystemDetailRouter
}

class SystemDetailRouterContainer: Container
{
    // MARK: - Variables
    
    var system: System
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(system: System, context: Context, stream: Stream)
    {
        self.system = system
        self.context = context
        self.stream = stream
    }
}

extension SystemDetailRouterContainer: SystemDetailRouterFactory
{
    func makeRouter() -> SystemDetailRouter
    {
        .init(container: self)
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
        let detail = stock.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToFlowDetail(flow: Flow)
    {
        let detail = flow.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToProcessDetail(flow: Task)
    {
        let detail = flow.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToEventDetail(event: Event)
    {
        let detail = event.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToNoteDetail(note: Note)
    {
        let detail = note.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
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
    // TODO: Should systems have tasks? I.E this is my safety system, and it has tasks
    // to follow? Not sure...
    // TODO: Also, TASK should be PROCESS because it's clearer. CoreData throws an error though...
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
            routeToFlowDetail(flow: flow)
//            if let flow = flow as? Flow
//            {
//                routeToFlowDetail(flow: flow)
//            }
//            else if let flow = flow as? Task
//            {
//                routeToProcessDetail(flow: flow)
//            }
//            else
//            {
//                fatalError("Cannot use an abstract Flow")
//            }
//        case 3: // Events
//            let event = container.system.unwrappedEvents[indexPath.row]
//            routeToEventDetail(event: event)
        case 3: // Notes
            let note = container.system.unwrappedNotes[indexPath.row]
            routeToNoteDetail(note: note)
        default:
            assertionFailure("Section doesn't exist")
            break
        }
    }
}
