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
    
    /// The reason this is necessary is to call the `registration` function so that it's created BEFORE the
    /// cell provider. Otherwise, we'll get an error that the registration is being created every time (not true)
    var headerRegistration = HeaderItem.registration
    var textEditRegistration = TextEditItem.registration
    var toggleRegistration = ToggleItem.registration
    var detailRegistration = DetailItem.registration
    
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
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.headerRegistration,
                    for: indexPath,
                    item: item)
            case .text(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.textEditRegistration,
                    for: indexPath,
                    item: item)
            case .toggle(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.toggleRegistration,
                    for: indexPath,
                    item: item)
            case .detail(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.detailRegistration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    override func makeInitialModel() -> ListControllerBuilder<EventDetailSection, EventDetailItem>.ListModel
    {
        [
            .info: makeInfoItems(),
            .conditions: makeConditionsItems(),
            .flows: makeFlowsItems(),
            .history: makeHistoryItems()
        ]
    }
    
    private func makeInfoItems() -> [EventDetailItem]
    {
        [
            EventDetailItem.header(.init(text: .info, image: nil))
        ]
    }
    
    private func makeConditionsItems() -> [EventDetailItem]
    {
        [
            EventDetailItem.header(.init(
                text: .conditions,
                image: Icon.condition.image,
                link: {
                    print("Tapped link on condition ")
                },
                add: {
                    print("Tapped add on condition")
                }))
        ]
    }
    
    private func makeFlowsItems() -> [EventDetailItem]
    {
        [
            EventDetailItem.header(.init(
                text: .flows,
                image: Icon.flow.image,
                disclosure: {
                    print("Disclosure was tapped on flow")
                },
                link: {
                    print("Link was tapped")
                },
                add: {
                    print("Add was tapped")
                }))
        ]
    }
    
    private func makeHistoryItems() -> [EventDetailItem]
    {
        [
            EventDetailItem.header(.init(text: .history, image: nil))
        ]
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
        
        title = builder.event.title
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reload(animated: animated)
    }
}
