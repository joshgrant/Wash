//
//  Event+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData

extension Event: SymbolNamed {}
extension Event: Pinnable {}
extension Event: Historable {}

public extension Event
{
    override var description: String
    {
        dashboardDescription
    }
    
    var dashboardDescription: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.event.text
        return "\(icon) \(name)"
    }
}

extension Event: Printable
{
    var shouldTrigger: Bool { isSatisfied && isActive }
    
    var isSatisfied: Bool
    {
        let conditions = unwrappedConditions
        // If we think that an event shouldn't be satisfied if it has no conditions... then
        // uncomment the following line. But in the case that we have the kill switch,
        // it's essentially a condition
//        guard conditions.count > 0 else { return false }
        
        for condition in conditions
        {
            if !condition.isSatisfied
            {
                return false
            }
        }
        
        return true
    }
    
    var fullDescription: String
    {
        let name = unwrappedName ?? ""
        let range = Date(timeIntervalSinceReferenceDate: 0) ..< Date(timeIntervalSinceReferenceDate: cooldownSeconds)
        let cooldown = range.formatted(.components(style: .abbreviated, fields: [.second, .minute, .hour, .day, .week, .month, .year]))
        let trigger = lastTrigger?.formatted(date: .abbreviated, time: .shortened) ?? "nil"
        return
"""
Name:           \(name)
Is Active:      \(isActive)
Is Satisfied:   \(isSatisfied)
Cooldown:       \(cooldown)
Last Trigger:   \(trigger)
Condition Type: \(conditionType)
Conditions:     \(unwrappedConditions)
Flows:          \(unwrappedFlows)
Stocks:         \(unwrappedStocks)
"""
    }
}

public extension Event
{
    var conditionType: ConditionType
    {
        get
        {
            ConditionType(rawValue: conditionTypeRaw) ?? .fallback
        }
        set
        {
            conditionTypeRaw = newValue.rawValue
        }
    }
}

public extension Event
{
    static func activeAndSatisfiedEvents(context: Context) -> [Event]
    {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let events = (try? context.fetch(request)) ?? []
        
        var trueEvents: [Event] = []
        
        for event in events
        {
            if event.shouldTrigger
            {
                trueEvents.append(event)
            }
        }
        
        return trueEvents
    }
}

public extension Event
{
    var unwrappedConditions: [Condition]
    {
        return unwrapped(\Event.conditions)
    }
    
    var unwrappedFlows: [Flow]
    {
        unwrapped(\Event.flows)
    }
    
    var unwrappedStocks: [Stock]
    {
        unwrapped(\Event.stocks)
    }
}
