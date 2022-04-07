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

extension Priority
{
    static let fallback: Priority = .linear
}
