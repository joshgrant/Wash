//
//  EventDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import Foundation
import UIKit

class EventDetailRouter: Unique
{
    enum Route
    {
        case conditionInfo
        case entityDetail(Entity)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    var stream: Stream
    var context: Context
    
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(stream: Stream, context: Context)
    {
        self.stream = stream
        self.context = context
        subscribe(to: stream)
    }
    
    deinit
    {
        unsubscribe(from: stream)
    }
    
    // MARK: - Routing
    
    func route(to route: Route) {
        switch route {
        case .conditionInfo:
            routeToConditionInfo()
        case .entityDetail(let entity):
            routeToEntityDetail(with: entity)
        }
    }
    
    private func routeToConditionInfo() {
        
    }
    
    private func routeToEntityDetail(with entity: Entity)
    {
        let detailController = entity.detailController(context: context, stream: stream)
        delegate?.navigationController?.pushViewController(detailController, animated: true, completion: nil)
    }
}

extension EventDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message {
        case let x as EntitySelectionMessage:
            routeToEntityDetail(with: x.entity)
        default:
            break
        }
    }
}
