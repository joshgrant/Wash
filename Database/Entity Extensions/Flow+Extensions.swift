//
//  Flow+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation
import CoreData

extension Flow: SymbolNamed {}
extension Flow: Pinnable {}
extension Flow: Historable {}

// TODO: Flow "amounts" can be dynamic or static - i.e for some "user-completed" flows
// the amount should be "enterable" like - how much water did you just drinik?

public extension Flow
{
    override var description: String
    {
        dashboardDescription
    }
    
    var dashboardDescription: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.flow.text
        return "\(icon) \(name)"
    }
    
    var runningDescription: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.flow.text
        let amount = amountPerSecond.formatted(.number.precision(.fractionLength(4)))
        let progress = (1 - (amountRemaining / self.amount)).formatted(.percent)
        return "\(icon): \(name), \(amount)/s, \(progress)"
    }
}

extension Flow: Printable
{
    var amountPerSecond: Double { return amount / duration }
    
    var percentComplete: Double { return amountRemaining / amount }
    
    var fullDescription: String
    {
        let delay = Date(timeIntervalSinceReferenceDate: 0) ..< Date(timeIntervalSinceReferenceDate: delay)
        let duration = Date(timeIntervalSinceReferenceDate: 0) ..< Date(timeIntervalSinceReferenceDate: duration)
        
        return
"""
Name:                       \(unwrappedName ?? "")
Amount:                     \(amount)
Delay:                      \(delay.formatted(.components(style: .abbreviated)))
Duration:                   \(duration.formatted(.components(style: .abbreviated)))
Requires User Completion:   \(requiresUserCompletion)
Is running:                 \(isRunning)
Repeats:                    \(repeats)
Events:                     \(events?.allObjects ?? [])
From:                       \(from?.description ?? "nil")
To:                         \(to?.description ?? "nil")
History:                    \(history?.allObjects ?? [])
"""
    }
}

extension Flow
{
    var needsUserExecution: Bool
    {
        // If `requiresUserCompletion` is true
        // If `events` are all satisfied
        // If not running currently
        
        var allEventsSatisfied = true
        
        for event: Event in unwrapped(\Flow.events) {
            if !event.isSatisfied {
                allEventsSatisfied = false
                break
            }
        }
        
        return requiresUserCompletion && !isRunning && allEventsSatisfied
    }
    
    /// When the flow is running, and the program is quit, we need to re-run it.
    func resume(context: Context)
    {
        runHelper(verbose: false, context: context)
    }
    
    func run(fromUser: Bool = false, verbose: Bool = false, context: Context)
    {
        if isRunning
        {
            if verbose { print("Already running!") }
            return
        }
        
        isRunning = true
        
        amountRemaining = amount
        
        // 1. Wait delay seconds
        // 2. Calculate the amount per second (amount / duration)
        // 3. On a timer, subtract the amount of aps from "from" and add it to "to"
        // 4. If "from" has aps or less, get that amount and add it to "to"
        // 5. If "from" has 0, finish the run
        // 6. If "to" is at the max value, also finish the run
        
        if verbose
        {
            let date = Date.now.formatted(.dateTime.day().hour().minute().second())
            print("Starting. Waiting for \(delay) seconds @ \(date)")
        }
        
        if delay >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else
                {
                    if verbose { print("No `self` in run loop. Exiting") }
                    return
                }
                if verbose { print("Delay completed.") }
                self.runHelper(verbose: verbose, context: context)
            }
        } else {
            runHelper(verbose: verbose, context: context)
        }
    }

    func runHelper(verbose: Bool, context: Context)
    {
        if verbose { print("Entering run helper") }
        
        guard let fromSource = from?.source else
        {
            if verbose { print("No from source") }
            isRunning = false
            return
        }
        
        guard let fromMin = from?.minimum else
        {
            if verbose { print("No from minimum") }
            isRunning = false
            return
        }
        
        guard let toSource = to?.source else
        {
            if verbose { print("No to source") }
            isRunning = false
            return
        }
        
        guard let toMax = to?.maximum else
        {
            if verbose { print("No to maximum") }
            isRunning = false
            return
        }
        
        let aps = amountPerSecond
        
        var amountToSubtract: Double = min(aps, amountRemaining)
        
        if fromSource.value - aps < fromMin.value
        {
            amountToSubtract = fromSource.value
        }
        
        if toSource.value + amountToSubtract > toMax.value
        {
            amountToSubtract = toMax.value - toSource.value
        }
        
        if amountToSubtract <= 0
        {
            // logHistory(.finished, context: database.context)
            
            if verbose { print("Done!") }
            self.isRunning = false
            
            if repeats
            {
                run(fromUser: false, verbose: verbose, context: context)
            }
            
            return
        }
        
        if verbose { print("Moving resources...") }
        if verbose { print("From: \(fromSource.value), to: \(toSource.value), amount: \(amountToSubtract)") }
        
        fromSource.value -= amountToSubtract
        toSource.value += amountToSubtract
        
        fromSource.logHistory(.updatedValue, context: context)
        toSource.logHistory(.updatedValue, context: context)
        
        if verbose { print("Re-scheduling for 1 second") }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else
            {
                if verbose { print("No self in run helper") }
                self?.isRunning = false
                return
            }
            
            if verbose { print("Begin re-entry of run helper") }
            self.amountRemaining = self.amountRemaining - amountToSubtract
            self.runHelper(verbose: verbose, context: context)
        }
    }
}

extension Flow: Comparable
{
    public static func < (lhs: Flow, rhs: Flow) -> Bool
    {
        (lhs.unwrappedName ?? "") < (rhs.unwrappedName ?? "")
    }
}

extension Flow
{
    static func runningFlows(in context: Context) -> [Flow]
    {
        let request: NSFetchRequest<Flow> = Flow.fetchRequest()
        request.predicate = NSPredicate(format: "isRunning == true")
        let result = (try? context.fetch(request)) ?? []
        return result
    }
}
