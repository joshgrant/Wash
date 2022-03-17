//
//  Priority.swift
//  Core
//
//  Created by Joshua Grant on 10/2/20.
//

import Foundation

public enum Priority: Int16, CaseIterable
{
    case linear
    case quadratic
    case exponential
}

extension Priority: FallbackProtocol
{
    static let fallback: Priority = .linear
}

extension Priority
{
    static func random() -> Priority
    {
        allCases.randomElement()!
    }
}
