//
//  EventDetailBuilder.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import UIKit

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
    
    weak var textEditDelegate: UITextFieldDelegate?
    weak var toggleDelegate: ToggleItemDelegate?
    
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
            .header(.init(text: .info, image: nil)),
            .text(.init(text: event.title, placeholder: .title, keyboardType: .default, tag: 1, delegate: textEditDelegate)),
            .toggle(.init(text: .active, isOn: event.isActive, delegate: toggleDelegate))
        ]
    }
    
    private func makeConditionsItems() -> [EventDetailItem]
    {
        let conditions: [Condition] = event.unwrapped(\Event.conditions)
        var eventItems: [EventDetailItem] = conditions.map
        {
            .detail(.init(text: $0.title))
        }
        
        eventItems.insert(.header(.init(
            text: .conditions,
            image: Icon.condition.image,
            link: {
                print("Tapped link on condition ")
            },
            add: {
                print("Tapped add on condition")
            })), at: 0)
        
        return eventItems
    }
    
    private func makeFlowsItems() -> [EventDetailItem]
    {
        let flows: [Flow] = event.unwrapped(\Event.flows)
        var flowItems: [EventDetailItem] = flows.map
        {
            .detail(.init(text: $0.title))
        }
        
        flowItems.insert(.header(.init(
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
            })), at: 0)
        
        return flowItems
    }
    
    private func makeHistoryItems() -> [EventDetailItem]
    {
        [
            .header(.init(text: .history, image: nil))
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
