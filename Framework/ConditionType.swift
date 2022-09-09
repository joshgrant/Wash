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

extension ConditionType
{
    static let fallback: ConditionType = .all
}

extension ConditionType
{
    init(string: String) throws
    {
        switch string.lowercased()
        {
        case "all":
            self = .all
        case "any":
            self = .any
        default:
            throw ParsingError.invalidConditionType(string)
        }
    }
}
