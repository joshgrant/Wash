//
//  EventDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import Foundation
import UIKit

enum EventDetailSection: Hashable
{
    case info
    case conditions
    case flows
    case history
}

enum EventDetailItem: Hashable
{
    case header(HeaderItem)
    case text(TextEditItem)
    case toggle(ToggleItem)
    // TODO: Condition Item
    case detail(DetailItem)
}

extension EventDetailItem: Identifiable
{
    var id: UUID
    {
        switch self
        {
        case .header(let item): return item.id
        case .text(let item): return item.id
        case .toggle(let item): return item.id
        case .detail(let item): return item.id
        }
    }
}

protocol EventFactory: Factory
{
    func makeController() -> EventDetailController
    func makeRouter() -> EventDetailRouter
}

class EventDetailRouterContainer: Container
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

class EventDetailRouter
{
    // Route to condition info
    // Route to condition detail
    // Route to entity detail (flow)
    // Route to history (^)
    
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

class EventDetailBuilder: ListControllerBuilder<EventDetailSection, EventDetailItem>
{
    // MARK: - Variables
    
    var event: Event
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(event: Event, context: Context, stream: Stream)
    {
        self.event = event
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    override func makeCellProvider() -> ListControllerBuilder<EventDetailSection, EventDetailItem>.CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                fatalError()
            case .text(let item):
                fatalError()
            case .toggle(let item):
                fatalError()
            case .detail(let item):
                fatalError()
            }
        }
    }
    
    override func makeInitialModel() -> ListControllerBuilder<EventDetailSection, EventDetailItem>.ListModel
    {
        [:] // Populate with sections and data...
    }
}

extension EventDetailBuilder: EventFactory
{
    func makeController() -> EventDetailController {
        .init(builder: self)
    }
    
    func makeRouter() -> EventDetailRouter {
        .init(stream: stream, context: context)
    }
}

class EventDetailController: ListController<EventDetailSection, EventDetailItem, EventDetailBuilder>
{
    // MARK: - Variables
    
    var router: EventDetailRouter
    
    // MARK: - Initialization
    
    override init(builder: EventDetailBuilder)
    {
        self.router = builder.makeRouter()
        super.init(builder: builder)
    }
}
