//
//  App.swift
//  Wash
//
//  Created by Joshua Grant on 9/9/22.
//

import Foundation
import CoreData

class App
{
    lazy var database = Database()
    lazy var workspace = Workspace(database: database)
    lazy var heartbeat = Heartbeat(start: start,
                                  inputLoop: inputLoopBlock,
                                  eventLoop: eventLoopBlock,
                                  cleanup: cleanup)
}

// MARK: - Heartbeat handlers

extension App
{
    func start(_ completion: @escaping Completion)
    {
        print("Hello, world!")
        
        let runningFlows = Flow.runningFlows(in: database.context)
        if runningFlows.count > 0
        {
            print("Re-starting \(runningFlows.count) flows.")
            for flow in runningFlows
            {
                flow.resume(context: database.context)
                // The only problem with this is that it's interrupted
                // halfway through... We need some progress indicator
                // on a flow that shows how far we've gotten and
                // when we quit, we can just resume at that progress...
            }
        }
        
        completion()
    }
    
    func inputLoopBlock(_ heartbeat: Heartbeat)
    {
        guard let input = readLine() else { return }
        guard let command = Command(input: input, workspace: workspace, database: database) else { return }
        
        do
        {
            workspace.lastResult = try command.run()
            workspace.display()
        }
        catch
        {
            print("Error thrown from handling input: \(error)")
        }
    }
    
    func eventLoopBlock(_ heartbeat: Heartbeat)
    {
        evaluateActiveEvents(context: database.context)
        evaluateInactiveEvents(context: database.context)
        workspace.update()
    }
    
    func cleanup(_ completion: @escaping Completion)
    {
        database.context.perform { [unowned self] in
            let allEvents: [Event] = Event.all(context: database.context)
            allEvents.forEach { $0.lastTrigger = nil }
            database.context.quickSave()
            completion()
        }
    }
}

// MARK: - Utility

extension App
{
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
                    flow.run(context: context)
                }
            }
            event.lastTrigger = Date()
            event.isActive = false
        }
    }
}
