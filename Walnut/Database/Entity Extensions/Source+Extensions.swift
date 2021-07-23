//
//  Source+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

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
    
    // TODO: Prevent user from entering dates before the reference date...
    var dateValue: Date
    {
        if value < 0
        {
            return Date()
        }
        else
        {
            return Date(timeIntervalSinceReferenceDate: value)
        }
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
