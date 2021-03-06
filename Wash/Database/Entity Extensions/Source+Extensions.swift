//
//  Source+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

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
        get
        {
            Int(value) == 1
        }
        set
        {
            value = newValue ? 1 : 0
        }
    }
    
    var dateValue: Date
    {
        get
        {
            if value < 0
            {
                return Date.now
            }
            else
            {
                return Date(timeIntervalSinceReferenceDate: value)
            }
        }
        set
        {
            value = newValue.timeIntervalSinceReferenceDate
        }
    }
    
    var infiniteValue: Double
    {
        get
        {
            value >= 0 ? Double.infinity : -Double.infinity
        }
        set
        {
            value = newValue >= 0 ? Double.infinity : -Double.infinity
        }
    }
    
    var percentValue: Double
    {
        get
        {
            value.constrained(min: 0, max: 100)
        }
        set
        {
            value = newValue.constrained(min: 0, max: 100)
        }
    }
    
    var numberValue: Double
    {
        get
        {
            value
        }
        set
        {
            value = newValue
        }
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
            
            // The current date
            if dateValue.timeIntervalSinceReferenceDate < 0
            {
                return Date.now.formatted(.dateTime.day().month().year())
            }
            else
            {
                return dateValue.formatted(.dateTime.day().month().year())
            }
        case .infinite:
            return infiniteValue > 0 ? "Infinity" : "Negative Infinity"
        case .percent:
            return String(format: "%i", Int(percentValue))
        case .number:
            return String(format: "%.2f", numberValue)
        }
    }
}
