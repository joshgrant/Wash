//
//  main.swift
//  Wash
//
//  Created by Joshua Grant on 2/18/22.
//

import Foundation
import CoreData
import SpriteKit
import Core

let database = Database()

let source = ContextPopulator.fetchOrMakeSourceStock(context: database.context)
let sink = ContextPopulator.fetchOrMakeSinkStock(context: database.context)

var workspace: [Entity] = [source, sink]

print("Hello, world!")

var lastCommand = CommandData(input: "")
var lastResult: [Entity] = []

let inputLoop: (Heartbeat) -> Void = { heartbeat in
    guard let input = readLine() else { return }
    let commandData = CommandData(input: input)
    let command = Command(commandData: commandData, workspace: &workspace, lastResult: lastResult)
    lastResult = command?.run(database: database) ?? []
    print(workspace)
}

let eventLoop: (Heartbeat) -> Void = { heartbeat in
    evaluateActiveEvents(context: database.context)
    evaluateInactiveEvents(context: database.context)
}

Heartbeat.init(inputLoop: inputLoop, eventLoop: eventLoop)
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

// TODO: Questions - an event may be active for a long time.
/// Options: 1. Kill switch. Once an event is run, it gets set to "isActive: false". Add a "cooldown" value that determines how long until the event is active again
// TODO: Automatically add a condition and stock upon event creation (isActive) ?? and
func evaluateActiveEvents(context: Context)
{
    let events = Event.activeAndSatisfiedEvents(context: context)
    for event in events
    {
        for flow in event.unwrappedFlows
        {
            if !flow.requiresUserCompletion
            {
                flow.run()
            }
            else
            {
                // TODO: FIX THIS
                // Add the flow to the ones requiring user completion???
            }
        }
        event.lastTrigger = Date()
        event.isActive = false
    }
}
