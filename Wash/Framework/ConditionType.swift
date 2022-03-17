//
//  ConditionType.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

public enum ConditionType: Int16, CaseIterable
{
    case all
    case any
}

extension ConditionType: FallbackProtocol
{
    static let fallback: ConditionType = .all
}

extension ConditionType
{
    init?(_ string: String)
    {
        switch string
        {
        case "all": self = .all
        case "any": self = .any
        default:    self.init(rawValue: .max)
        }
    }
}
