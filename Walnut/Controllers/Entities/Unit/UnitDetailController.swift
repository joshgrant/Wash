//
//  UnitDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

enum UnitDetailSection: Hashable
{
    case info
}

enum UnitDetailItem: Hashable
{
    case header(HeaderItem)
    case name(TextEditItem)
    case abbreviation(TextEditItem)
    case baseUnit(ToggleItem)
    case relativeTo(DetailItem)
}

extension UnitDetailItem: Identifiable
{
    var id: UUID
    {
        switch self
        {
        case .header(let item): return item.id
        case .name(let item): return item.id
        case .abbreviation(let item): return item.id
        case .baseUnit(let item): return item.id
        case .relativeTo(let item): return item.id
        }
    }
}

protocol UnitDetailFactory: Factory
{
    func makeController() -> UnitDetailController
}

class UnitDetailBuilder: ListControllerBuilder<UnitDetailSection, UnitDetailItem>
{
    // MARK: - Variables
    
    var unit: Unit
    
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(unit: Unit, context: Context, stream: Stream)
    {
        self.unit = unit
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func makeController() -> UnitDetailController
    {
        .init(builder: self)
    }
    
    override func makeCellProvider() -> ListControllerBuilder<UnitDetailSection, UnitDetailItem>.CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .name(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .abbreviation(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .baseUnit(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .relativeTo(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    override func makeInitialModel() -> ListControllerBuilder<UnitDetailSection, UnitDetailItem>.ListModel
    {
        [
            .info: makeInfoItems()
        ]
    }
    
    private func makeInfoItems() -> [UnitDetailItem]
    {
        var items: [UnitDetailItem] = []
        
        items.append(.header(.init(text: .info)))
        items.append(.name(.init(
                            text: unit.title,
                            placeholder: .title,
                            keyboardType: .default)))
        items.append(.abbreviation(.init(
                                    text: unit.abbreviation,
                                    placeholder: .abbreviation,
                                    keyboardType: .default)))
        items.append(.baseUnit(.init(
                                text: .baseUnit,
                                isOn: unit.isBase)))
        
        if !unit.isBase, let parent = unit.parent
        {
            items.append(.relativeTo(.init(text: parent.title)))
        }
        
        return items
    }
}

class UnitDetailController: ListController<UnitDetailSection, UnitDetailItem, UnitDetailBuilder>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    override init(builder: UnitDetailBuilder)
    {
        super.init(builder: builder)
        subscribe(to: builder.stream)
        
        title = builder.unit.title
    }
    
    deinit
    {
        unsubscribe(from: builder.stream)
    }
}

extension UnitDetailController: Subscriber
{
    func receive(message: Message)
    {
        
    }
}
