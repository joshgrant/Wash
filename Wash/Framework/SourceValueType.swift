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

extension SourceValueType
{
    static func random() -> SourceValueType
    {
        Self.allCases.randomElement()!
    }
}
