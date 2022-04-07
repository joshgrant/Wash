//
//  HistoryEvent.swift
//  Wash
//
//  Created by Joshua Grant on 3/26/22.
//

import Foundation

public enum HistoryEvent: Int16, CaseIterable
{
    case created
    case updated
    case deleted
}

extension HistoryEvent
{
    static let fallback: HistoryEvent = .created
}

extension HistoryEvent: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
        case .created: return "Created".localized
        case .updated: return "Updated".localized
        case .deleted: return "Deleted".localized
        }
    }
}
