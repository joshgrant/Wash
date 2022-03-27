//
//  main.swift
//  Wash
//
//  Created by Joshua Grant on 2/18/22.
//

import Foundation
import CoreData
import SpriteKit

let database = Database()

let source = ContextPopulator.sourceStock(context: database.context)
let sink = ContextPopulator.sinkStock(context: database.context)

let year = ContextPopulator.yearStock(context: database.context)
let month = ContextPopulator.monthStock(context: database.context)
let day = ContextPopulator.dayStock(context: database.context)
let hour = ContextPopulator.hourStock(context: database.context)
let minute = ContextPopulator.minuteStock(context: database.context)
let second = ContextPopulator.secondStock(context: database.context)

var workspace: [Entity] = [source, sink]
var lastResult: [Entity] = []

let start: DispatchCompletion = { completion in
    
    print("Hello, world!")
    
    let runningFlows = Flow.runningFlows(in: database.context)
    if runningFlows.count > 0
    {
        print("Re-starting \(runningFlows.count) flows.")
        for flow in runningFlows
        {
            flow.resume()
            // The only problem with this is that it's interrupted
            // halfway through... We need some progress indicator
            // on a flow that shows how far we've gotten and
            // when we quit, we can just resume at that progress...
        }
    }
    
    completion()
}

let inputLoop: (Heartbeat) -> Void = { heartbeat in
    guard let input = readLine() else { return }
    let commandData = CommandData(input: input)
    let command = Command(commandData: commandData, workspace: &workspace, lastResult: lastResult, quit: &heartbeat.shouldQuit)
    lastResult = command?.run(database: database) ?? []
    
    print(workspace.formatted(EntityListFormatStyle()))
}

let eventLoop: (Heartbeat) -> Void = { heartbeat in
    
    evaluateActiveEvents(context: database.context)
    evaluateInactiveEvents(context: database.context)
    
    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .now)
    year.current = Double(components.year ?? 0)
    month.current = Double(components.month ?? 0)
    day.current = Double(components.day ?? 0)
    hour.current = Double(components.hour ?? 0)
    minute.current = Double(components.minute ?? 0)
    second.current = Double(components.second ?? 0)
}

let cleanup: DispatchCompletion = { completion in
    // Stop all of the flows
    database.context.perform {
        // Clear last trigger date
        let allEvents: [Event] = Event.all(context: database.context)
        for event in allEvents
        {
            event.lastTrigger = nil
        }
        
        database.context.quickSave()
        
        completion()
    }
}

Heartbeat(
    start: start,
    inputLoop: inputLoop,
    eventLoop: eventLoop,
    cleanup: cleanup)

RunLoop.current.run()

func evaluateInactiveEvents(context: Context)
{
    let request: NSFetchRequest<Event> = Event.fetchRequest()
    request.predicate = NSPredicate(format: "isActive == false")
    let events = (try? context.fetch(request)) ?? []
    for event in events
    {
        guard let lastTrigger = event.lastTrigger else { continue }
        let cooldownDate = Date(timeInterval: event.cooldownSeconds, since: lastTrigger)
        if cooldownDate.timeIntervalSinceNow <= 0
        {
            event.isActive = true
        }
    }
}

func evaluateActiveEvents(context: Context)
{
    let events = Event.activeAndSatisfiedEvents(context: context)
    for event in events
    {
        for flow in event.unwrappedFlows
        {
            if !flow.requiresUserCompletion && !flow.isRunning
            {
                flow.run()
            }
        }
        event.lastTrigger = Date()
        event.isActive = false
    }
}

struct EntityFormatStyle: FormatStyle
{
    typealias FormatInput = Entity
    typealias FormatOutput = String
    
    func format(_ value: Entity) -> String {
        return value.description
    }
}

struct EntityListFormatStyle: FormatStyle
{
    typealias FormatInput = [Entity]
    typealias FormatOutput = String

    func format(_ value: [Entity]) -> String
    {
        var output = "["
        
        // TODO: Maybe with indexes is an option?
        for item in value.enumerated()
        {
            output += "\(item.offset): \(EntityFormatStyle().format(item.element)), "
        }
        
        if output.count > 2 {
            output.removeLast(2)
        }
        
        output += "]"
        
        return output
    }
}
