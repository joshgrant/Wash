//
//  EntityType.swift
//  Center
//
//  Created by Joshua Grant on 5/29/21.
//

import Foundation
import CoreData

public enum EntityType
{
    case stock
    case flow
    case task
    case event
    case conversion
    case condition
    case symbol
    case note
    case unit
    
    static var libraryVisible: [EntityType]
    {
        [
            .stock,
            .flow,
            .task,
            .event,
            .conversion,
            .condition,
            .symbol,
            .note,
            .unit
        ]
    }
    
    var title: String
    {
        switch self
        {
        case .stock: return "Stocks".localized
        case .flow: return "Flows".localized
        case .task: return "Tasks".localized
        case .event: return "Events".localized
        case .conversion: return "Conversions".localized
        case .condition: return "Conditions".localized
        case .symbol: return "Symbols".localized
        case .note: return "Notes".localized
        case .unit: return "Units".localized
        }
    }
    
    var icon: Icon
    {
        switch self
        {
        case .stock: return .stock
        case .flow: return .flow
        case .task: return .task
        case .event: return .event
        case .conversion: return .conversion
        case .condition: return .condition
        case .symbol: return .symbol
        case .note: return .note
        case .unit: return .unit
        }
    }
    
    var managedObjectType: Entity.Type
    {
        switch self
        {
        case .stock: return Stock.self
        case .flow: return Flow.self
        case .task: return Task.self
        case .event: return Event.self
        case .conversion: return Conversion.self
        case .condition: return Condition.self
        case .symbol: return Symbol.self
        case .note: return Note.self
        case .unit: return Unit.self
        }
    }
    
    func insertNewEntity(into context: Context) -> Entity
    {
        // TODO: Verify that this works...
        let description = managedObjectType.entity()
        return Entity(entity: description, insertInto: context)
    }
    
    func count(in context: Context) -> Int
    {
        let request: NSFetchRequest<NSFetchRequestResult> = managedObjectType.fetchRequest()
        request.includesPropertyValues = false
        request.includesSubentities = false
        do {
            return try context.fetch(request).count
        } catch {
            assertionFailure(error.localizedDescription)
            return 0
        }
    }
    
    static func type(from entityType: Entity.Type) -> EntityType?
    {
        switch entityType
        {
        case is Stock.Type: return .stock
        case is Flow.Type: return .flow
        case is Task.Type: return .task
        case is Event.Type: return .event
        case is Conversion.Type: return .conversion
        case is Condition.Type: return .condition
        case is Symbol.Type: return .symbol
        case is Note.Type: return .note
        case is Unit.Type: return .unit
        default:
            return nil
        }
    }
    
    static func type(from entity: Entity) -> EntityType?
    {
        switch entity
        {
        case is Stock: return .stock
        case is Flow: return .flow
        case is Task: return .task
        case is Event: return .event
        case is Conversion: return .conversion
        case is Condition: return .condition
        case is Symbol: return .symbol
        case is Note: return .note
        case is Unit: return .unit
        default:
            return nil
        }
    }
    
    static func configuration(for entity: Entity) -> EntityDetailViewController.DataSource
    {
        switch entity
        {
        case is Stock: return .stock
        case is Flow: return .flow
        case is Task: return .task
        case is Event: return .event
        case is Conversion: return .conversion
        case is Condition: return .condition
        case is Symbol: return .symbol
        case is Note: return .note
        case is Unit: return .unit
        default:
            fatalError("Unhandled entity")
        }
    }
}

extension EntityType: CaseIterable {}
