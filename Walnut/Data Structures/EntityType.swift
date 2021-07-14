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
    case unit
    
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
            .note,
            .unit
        ]
    }
    
    var title: String
    {
        switch self
        {
        case .system: return "Systems".localized
        case .stock: return "Stocks".localized
        case .flow: return "Flows".localized
        case .process: return "Processes".localized
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
        case .system: return .system
        case .stock: return .stock
        case .flow: return .flow
        case .process: return .process
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
        case .system: return System.self
        case .stock: return Stock.self
        case .flow: return TransferFlow.self
        case .process: return ProcessFlow.self
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
        case is System.Type: return .system
        case is Stock.Type: return .stock
        case is TransferFlow.Type: return .flow
        case is ProcessFlow.Type: return .process
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
        case is System: return .system
        case is Stock: return .stock
        case is TransferFlow: return .flow
        case is ProcessFlow: return .process
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
    
    func newController(context: Context?) -> UIViewController
    {
        switch self
        {
        case .unit:
            return NewUnitController(context: context)
        case .stock:
            return NewStockController(context: context)
        default:
            fatalError("No controller")
        }
    }
}

extension EntityType: CaseIterable {}
