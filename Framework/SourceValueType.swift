//
//  SourceValueType.swift
//  Walnut
//
//  Created by Joshua Grant on 7/23/21.
//

import Foundation

/// Maps to Source.valueTypeRaw
public enum SourceValueType: Int16, CaseIterable
{
    case boolean
    case infinite
    case percent
    case number
    
    case date
    
    init(string: String) throws
    {
        switch string
        {
        case "boolean": self = .boolean
        case "infinite", "infinity": self = .infinite
        case "percent": self = .percent
        case "number", "decimal": self = .number
        case "date": self = .date
        default:
            throw ParsingError.invalidSourceValueType(string)
        }
    }
}

extension SourceValueType: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
        case .boolean: return "Boolean".localized
        case .date: return "Date".localized
        case .infinite: return "Infinite".localized
        case .percent: return "Percent".localized
        case .number: return "Number".localized
        }
    }
}
