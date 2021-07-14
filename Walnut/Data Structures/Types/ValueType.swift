//
//  ValueType.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

public enum ValueType: Int16, CaseIterable, CustomStringConvertible
{
    case boolean
    case decimal
    case integer
    case percent
    
    public var description: String
    {
        switch self
        {
        case .boolean: return "Boolean".localized
        case .decimal: return "Decimal".localized
        case .integer: return "Integer".localized
        case .percent: return "Percent".localized
        }
    }
}

extension ValueType: FallbackProtocol
{
    static var fallback: ValueType
    {
        .boolean
    }
}
