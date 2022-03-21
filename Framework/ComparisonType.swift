//
//  ComparisonType.swift
//  Core
//
//  Created by Joshua Grant on 10/2/20.
//

import Foundation

public enum ComparisonType: Int16, CaseIterable, Random
{
    case boolean
    case date
    case number
    
    init?(string: String)
    {
        switch string.lowercased()
        {
        case "bool", "boolean", "b":
            self = .boolean
        case "date", "d":
            self = .date
        case "number", "n":
            self = .number
        default:
            return nil
        }
    }
}

extension ComparisonType: CustomStringConvertible
{
    public var description: String
    {
        switch self {
        case .boolean:
            return "Boolean"
        case .date:
            return "Date"
        case .number:
            return "Number"
        }
    }
}

public enum BooleanComparisonType: Int16, CaseIterable, Random
{
    case equal
    case notEqual
    
    init?(string: String)
    {
        switch string
        {
        case "equal":
            self = .equal
        case "not-equal":
            self = .notEqual
        default:
            return nil
        }
    }
}

public enum DateComparisonType: Int16, CaseIterable, Random
{
    case after
    case before
    
    init?(string: String)
    {
        switch string
        {
        case "after":
            self = .after
        case "before":
            self = .before
        default:
            return nil
        }
    }
}

public enum NumberComparisonType: Int16, CaseIterable, Random
{
    case equal
    case notEqual
    case greaterThan
    case lessThan
    case greaterThanOrEqual
    case lessThanOrEqual
    
    init?(string: String)
    {
        switch string
        {
        case "equal":
            self = .equal
        case "not-equal":
            self = .notEqual
        case "gt":
            self = .greaterThan
        case "lt":
            self = .lessThan
        case "gtoe":
            self = .greaterThanOrEqual
        case "ltoe":
            self = .lessThanOrEqual
        default:
            return nil
        }
    }
}
