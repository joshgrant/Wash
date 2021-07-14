//
//  EntityType.swift
//  Center
//
//  Created by Joshua Grant on 5/29/21.
//

import Foundation
import UIKit
import CoreData

public enum EntityType
{
    case system
    case stock
    case flow
    case process
    case event
    case conversion
    case condition
    case symbol
    case note
    
    static var libraryVisible: [EntityType]
    {
        [
            .system,
            .stock,
            .flow,
            .process,
            .event,
            .conversion,
            .condition,
            .symbol,
            .note
        ]
    }
    
    var title: String
    {
        switch self
        {
        case .system: return "Systems"
        case .stock: return "Stocks"
        case .flow: return "Flows"
        case .process: return "Processes"
        case .event: return "Events"
        case .conversion: return "Conversions"
        case .condition: return "Conditions"
        case .symbol: return "Symbols"
        case .note: return "Notes"
        }
    }
    
    var icon: Icon
    {
        switch self
        {
        case .system: return .system
        case .stock: return .stock
        case .flow: return .flow
        case .process: return .process
        case .event: return .event
        case .conversion: return .conversion
        case .condition: return .condition
        case .symbol: return .symbol
        case .note: return .note
        }
    }
    
    var managedObjectType: Entity.Type
    {
        switch self
        {
        case .system: return System.self
        case .stock: return Stock.self
        case .flow: return TransferFlow.self
        case .process: return ProcessFlow.self
        case .event: return Event.self
        case .conversion: return Conversion.self
        case .condition: return Condition.self
        case .symbol: return Symbol.self
        case .note: return Note.self
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
    
    static func type(from entity: Entity) -> EntityType?
    {
        switch entity
        {
        case is System: return .system
        case is Stock: return .stock
        case is TransferFlow: return .flow
        case is ProcessFlow: return .process
        case is Event: return .event
        case is Conversion: return .conversion
        case is Condition: return .condition
        case is Symbol: return .symbol
        case is Note: return .note
        default:
            return nil
        }
    }
}

extension EntityType: CaseIterable {}
