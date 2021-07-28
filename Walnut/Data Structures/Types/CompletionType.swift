//
//  CompletionType.swift
//  Core
//
//  Created by Joshua Grant on 10/3/20.
//

import Foundation

/// The completion type for a flow?
public enum CompletionType: Int16, CaseIterable
{
    // TODO: Not sure which completion type suits them all
    case boolean
    case children
}

extension CompletionType
{
    static func random() -> CompletionType
    {
        allCases.randomElement()!
    }
}
