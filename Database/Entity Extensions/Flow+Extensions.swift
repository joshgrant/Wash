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
"""
Amount:                     \(amount)
Delay (seconds):            \(delay)
Duration (seconds):         \(duration)
Requuires User Completion:  \(requiresUserCompletion)
Events:                     \(events?.allObjects ?? [])
From:                       \(from?.description ?? "nil")
To:                         \(to?.description ?? "nil")
History:                    \(history?.allObjects ?? [])
"""
    }
}

extension Flow
{
    func run()
    {
        // 1. Wait delay seconds
        // 2. Calculate the amount per second (amount / duration)
        // 3. On a timer, subtract the amount of aps from "from" and add it to "to"
        // 4. If "from" has aps or less, get that amount and add it to "to"
        // 5. If "from" has 0, finish the run
        // 6. If "to" is at the max value, also finish the run
        
        print("Starting. Waiting for \(delay) seconds")
        // Not great.. but does the trick
        sleep(UInt32(delay))
        print("Delay completed.")
        runHelper(amount: amount)
    }

    func runHelper(amount: Double)
    {
        guard let fromSource = from?.source else
        {
            print("No from source")
            return
        }
        
        guard let fromMin = from?.minimum else
        {
            print("No from minimum")
            return
        }
        
        guard let toSource = to?.source else
        {
            print("No to source")
            return
        }
        
        guard let toMax = to?.maximum else
        {
            print("No to maximum")
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
            print("Done!")
            return
        }
        
        print("Moving resources...")
        print("From: \(fromSource.value), to: \(toSource.value), amount: \(amountToSubtract)")
        
        fromSource.value -= amountToSubtract
        toSource.value += amountToSubtract
        
        print("Sleeping for 1 second")
        sleep(1)
        runHelper(amount: amount - amountToSubtract)
    }
}
