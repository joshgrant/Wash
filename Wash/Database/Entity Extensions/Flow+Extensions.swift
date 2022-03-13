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
