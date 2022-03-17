//
//  HistoryEvent.swift
//  Core
//
//  Created by Joshua Grant on 10/2/20.
//

import Foundation

public enum HistoryEvent: Int16, CaseIterable
{
    case created
    case updated
    case deleted
}

extension HistoryEvent: FallbackProtocol
{
    static let fallback: HistoryEvent = .created
}

extension HistoryEvent
{
    static func random() -> HistoryEvent
    {
        allCases.randomElement()!
    }
}
