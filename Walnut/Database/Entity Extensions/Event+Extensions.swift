//
//  Event+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData

extension Event: Named {}
extension Event: Pinnable {}

public extension Event
{
    var conditionType: ConditionType {
        get {
            ConditionType(rawValue: conditionTypeRaw) ?? .fallback
        }
        set {
            conditionTypeRaw = newValue.rawValue
        }
    }
}

public extension Event
{
    static func makeUpcomingEventsPredicate() -> NSPredicate
    {
//        NSPredicate(value: false)
        
        // if conditionType is 'all', then we have to check each condition
        // if conditionType is 'any', then we just one has to pass
        
        // comparison is equal, not equal, less than, greater, etc.
        // priority is low, urgent, etc...
        
        // So upcoming events have a lefthandsource and a righthandsource that are both dates...
        // We check leftHand.valueType == .timeNow and rightHand.valueType == .date,
        // If the difference between leftHand and rightHand is less than threshold (let's say 1 week,
        // so 60 * 60 * 24 * 7) then we include it in the upcoming events...
        
        // Woof. Can we do this with a fetch request or do we need to filter?
        
//        NSPredicate { <#Any?#>, <#[String : Any]?#> in
//            <#code#>
//        }
        
//        NSPredicate(format: "conditionTypeRaw == %i", ConditionType.any)
//        let predicate = NSPredicate { item, bindings in
//            <#code#>
//        }
  
        // Can't use predicateWithBlock...
//        fatalError()
        
//        let events: NSFetchRequest<Event> = Event.fetchRequest()
        return NSPredicate(value: true)
    }
    
    static func makeUpcomingEventsFetchRequest() -> NSFetchRequest<Event>
    {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = makeUpcomingEventsPredicate()
        return fetchRequest
    }
    
    static func upcomingEvents(context: Context) -> [Event]
    {
        return []
//        var upcomingEvents: [Event] = []
//
//        let allEvents = Event.all(context: context)
//
//        for event in allEvents
//        {
//            var dateConditionSatisfied = false
//
//            let conditions: [Condition] = event.unwrapped(\Event.conditions)
//
//
//                if condition.leftHand!.valueType == .timeNow && condition.rightHand!.valueType == .date
//                {
//                    // This threshold represents a week. So dates less than 1 week apart are upcoming
//                    let threshold: Double = 60 * 60 * 24 * 7
//                    if condition.leftHand!.value - threshold <= condition.rightHand!.value
//                    {
//                        dateConditionSatisfied = true
//                    }
//                }
//                else
//                {
//
//                }
//
//        }
//
//        return upcomingEvents
    }
}

public extension Event
{
    static func eventsFromSources(_ sources: [Source]) -> [Event]
    {
        var targetEvents: [Event] = sources.flatMap {
            $0.conditionLeftHand?.unwrappedEvents ?? []
        }
        
        let valueEvents = sources.flatMap {
            $0.conditionRightHand?.unwrappedEvents ?? []
        }
        
        targetEvents.append(contentsOf: valueEvents)
        
        return targetEvents
    }
}
