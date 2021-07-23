//
//  Source+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

/// Maps to Source.valueTypeRaw
public enum SourceValueType: Int16, CaseIterable
{
    case boolean
    case date
    case infinite
    case percent
    case number
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

// TODO: Let's do testing next

public extension Source
{
    var valueType: SourceValueType
    {
        get
        {
            return SourceValueType(rawValue: valueTypeRaw)!
        }
        set
        {
            valueTypeRaw = newValue.rawValue
        }
    }
    
    var booleanValue: Bool
    {
        Int(value) == 1
    }
    
    var dateValue: Date
    {
        Date(timeIntervalSince1970: value)
    }
    
    var infiniteValue: Double
    {
        value > 0 ? Double.infinity : -Double.infinity
    }
    
    var percentValue: Double
    {
        value.constrained(min: 0, max: 100)
    }
    
    var numberValue: Double
    {
        value
    }
}

extension Source
{
    public override var description: String
    {
        switch valueType
        {
        case .boolean:
            return booleanValue ? "True".localized : "False".localized
        case .date:
            let formatter = DateFormatter() // TODO: Reuse
            return formatter.string(from: dateValue)
        case .infinite:
            return infiniteValue > 0 ? "Infinity" : "Negative Infinity"
        case .percent:
            return String(format: "%i", Int(percentValue))
        case .number:
            return String(format: "%.2f", numberValue)
        }
    }
}

//extension Source: Comparable
//{
//    public static func < (lhs: Source, rhs: Source) -> Bool
//    {
//        guard lhs.valueType == rhs.valueType else { fatalError("Comparing incompatible sources") }
//
//        switch lhs.valueType
//        {
//        case .boolean:
//            return false
//        case .date:
//            return lhs.dateValue < rhs.dateValue
//        case .infinite:
//            return lhs.infiniteValue < rhs.infiniteValue
//        case .percent:
//            return lhs.percentValue < rhs.percentValue
//        case .number:
//            return lhs.numberValue < rhs.numberValue
//        }
//    }
//}
