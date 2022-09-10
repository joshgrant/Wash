//
//  EntityType.swift
//  Center
//
//  Created by Joshua Grant on 5/29/21.
//

import Foundation
import CoreData

enum EntityType
{
    case stock
    case flow
    case event
    case condition
    case unit
    case system
    case process
    
    static var libraryVisible: [EntityType]
    {
        [
            .stock,
            .flow,
            .event,
            .condition,
            .unit,
            .system,
            .process
        ]
    }
    
    var title: String
    {
        switch self
        {
        case .stock: return "Stocks".localized
        case .flow: return "Flows".localized
        case .event: return "Events".localized
        case .condition: return "Conditions".localized
        case .unit: return "Units".localized
        case .system: return "Systems".localized
        case .process: return "Processes".localized
        }
    }
    
    var icon: Icon
    {
        switch self
        {
        case .stock: return .stock
        case .flow: return .flow
        case .event: return .event
        case .condition: return .condition
        case .unit: return .unit
        case .system: return .system
        case .process: return .task
        }
    }
    
    @available(*, deprecated)
    var managedObjectType: Entity.Type
    {
        switch self
        {
        case .stock: return Stock.self
        case .flow: return Flow.self
        case .event: return Event.self
        case .condition: return Condition.self
        case .unit: return Unit.self
        case .system: return System.self
        case .process: return Process.self
        }
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

    init(string: String) throws
    {
        switch string
        {
        case "stock": self = .stock
        case "flow": self = .flow
        case "event": self = .event
        case "condition": self = .condition
        case "unit": self = .unit
        case "system": self = .system
        case "process": self = .process
        default:
            throw ParsingError.invalidEntityType(string)
        }
    }
}

extension EntityType: CaseIterable {}
