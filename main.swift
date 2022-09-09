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
let workspace = Workspace(database: database)

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
    guard let command = Command(input: input, workspace: workspace, database: database) else { return }
    
    do
    {
        workspace.lastResult = try command.run()
        workspace.display()
    }
    catch
    {
        print("Error thrown from input: \(error)")
    }
}

let eventLoop: (Heartbeat) -> Void = { heartbeat in
    evaluateActiveEvents(context: database.context)
    evaluateInactiveEvents(context: database.context)
    workspace.update()
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
