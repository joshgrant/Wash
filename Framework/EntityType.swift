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
    
    @discardableResult
    func insertNewEntity(into context: Context, name: String?) -> Entity
    {
        switch self
        {
        case .stock:
            return makeStock(name: name, in: context)
        case .flow:
            return makeFlow(name: name, in: context)
        case .event:
            return makeEvent(name: name, in: context)
        case .condition:
            return makeCondition(name: name, in: context)
        case .unit:
            return makeUnit(name: name, in: context)
        case .system:
            return makeSystem(name: name, in: context)
        case .process:
            return makeProcess(name: name, in: context)
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

// MARK: - Creating entities

extension EntityType
{
    @discardableResult
    func makeStock(name: String?, in context: Context) -> Stock
    {
        let stock = Stock(context: context)
        stock.stateMachine = false
        stock.isPinned = false
        stock.createdDate = Date()
        
        let source = Source(context: context)
        source.valueType = .number
        source.value = 0
        stock.source = source
        
        let minimum = Source(context: context)
        minimum.valueType = .number
        minimum.value = 0
        stock.minimum = minimum
        
        let maximum = Source(context: context)
        maximum.valueType = .number
        maximum.value = 100
        stock.maximum = maximum
        
        let ideal = Source(context: context)
        ideal.valueType = .number
        ideal.value = 100
        stock.ideal = ideal
        
        if let name = name
        {
            stock.symbolName = Symbol(context: context, name: name)
        }
        
        stock.logHistory(.created, context: context)
        
        return stock
    }

    @discardableResult
    func makeFlow(name: String?, in context: Context) -> Flow
    {
        let flow = Flow(context: context)
        
        flow.amount = 1
        flow.delay = 1
        flow.duration = 1
        flow.requiresUserCompletion = false
        flow.repeats = false
        
        if let name = name
        {
            flow.symbolName = Symbol(context: context, name: name)
        }
        
        flow.logHistory(.created, context: context)
        
        return flow
    }

    @discardableResult
    func makeEvent(name: String?, in context: Context) -> Event
    {
        let event = Event(context: context)
        
        event.conditionType = .all
        event.isActive = true
        
        if let name = name
        {
            event.symbolName = Symbol(context: context, name: name)
        }
        
        event.logHistory(.created, context: context)
        
        return event
    }
    
    @discardableResult
    func makeCondition(name: String?, in context: Context) -> Condition
    {
        let condition = Condition(context: context)
        
        if let name = name
        {
            condition.symbolName = Symbol(context: context, name: name)
        }
        
        return condition
    }
    
    @discardableResult
    func makeUnit(name: String?, in context: Context) -> Unit
    {
        let unit = Unit(context: context)
        
        unit.isBase = true
        
        if let name = name
        {
            unit.symbolName = Symbol(context: context, name: name)
            unit.abbreviation = name
        }
        
        return unit
    }
    
    @discardableResult
    func makeSystem(name: String?, in context: Context) -> System
    {
        let system = System(context: context)
        
        if let name = name
        {
            system.symbolName = Symbol(context: context, name: name)
        }
        
        system.logHistory(.created, context: context)
        
        return system
    }
    
    @discardableResult
    func makeProcess(name: String?, in context: Context) -> Process
    {
        let process = Process(context: context)
        
        if let name = name
        {
            process.symbolName = Symbol(context: context, name: name)
        }
        
        process.logHistory(.created, context: context)
        
        return process
    }
}

extension EntityType: CaseIterable {}
