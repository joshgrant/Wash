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
}

extension Flow: Printable
{
    var fullDescription: String
    {
        let delay = Date(timeIntervalSinceReferenceDate: 0) ..< Date(timeIntervalSinceReferenceDate: delay)
        let duration = Date(timeIntervalSinceReferenceDate: 0) ..< Date(timeIntervalSinceReferenceDate: duration)
        
        return
"""
Amount:                     \(amount)
Delay:                      \(delay.formatted(.components(style: .abbreviated)))
Duration:                   \(duration.formatted(.components(style: .abbreviated)))
Requires User Completion:   \(requiresUserCompletion)
Is running:                 \(isRunning)
Events:                     \(events?.allObjects ?? [])
From:                       \(from?.description ?? "nil")
To:                         \(to?.description ?? "nil")
History:                    \(history?.allObjects ?? [])
"""
    }
}

extension Flow
{
    // TODO: Display this to the user...
    var needsUserExecution: Bool {
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
    
    func run(verbose: Bool = true)
    {
        if isRunning
        {
            if verbose { print("Already running!") }
            return
        }
        
        isRunning = true
        
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
        
        let date = Date(timeIntervalSinceNow: delay)
        RunLoop.current.schedule(after: .init(date)) { [weak self] in
            guard let self = self else
            {
                if verbose { print("No `self` in run loop. Exiting") }
                return
            }
            if verbose { print("Delay completed.") }
            self.runHelper(amount: self.amount, verbose: verbose)
        }
    }

    func runHelper(amount: Double, verbose: Bool = false)
    {
        if verbose { print("Entering run helper") }
        
        guard let fromSource = from?.source else
        {
            if verbose { print("No from source") }
            return
        }
        
        guard let fromMin = from?.minimum else
        {
            if verbose { print("No from minimum") }
            return
        }
        
        guard let toSource = to?.source else
        {
            if verbose { print("No to source") }
            return
        }
        
        guard let toMax = to?.maximum else
        {
            if verbose { print("No to maximum") }
            return
        }
        
        let aps = self.amount / duration
        
        var amountToSubtract: Double = min(aps, amount)
        
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
            if verbose { print("Done!") }
            self.isRunning = false
            return
        }
        
        if verbose { print("Moving resources...") }
        if verbose { print("From: \(fromSource.value), to: \(toSource.value), amount: \(amountToSubtract)") }
        
        fromSource.value -= amountToSubtract
        toSource.value += amountToSubtract
        
        if verbose { print("Re-scheduling for 1 second") }
        
        RunLoop.current.schedule(after: .init(.now.addingTimeInterval(1)), tolerance: .milliseconds(5)) { [weak self] in
            guard let self = self else
            {
                if verbose { print("No self in run helper") }
                return
            }
            
            if verbose { print("Begin re-entry of run helper") }
            self.runHelper(amount: amount - amountToSubtract, verbose: verbose)
        }
    }
}
