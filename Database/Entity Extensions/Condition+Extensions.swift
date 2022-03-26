//
//  Condition+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation

extension Condition: SymbolNamed {}

extension Condition
{
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.condition.text
        return "\(icon) \(name)"
    }
}

extension Condition: Printable
{
    var fullDescription: String
    {
        let comparisonDetail: String
        
        switch comparisonType
        {
        case .boolean:
            switch booleanComparisonType {
            case .notEqual: comparisonDetail = "Not equal"
            case .equal:    comparisonDetail = "Equal"
            default:        comparisonDetail = "nil:bool"
            }
        case .number:
            switch numberComparisonType {
            case .equal:                comparisonDetail = "Equal"
            case .notEqual:             comparisonDetail = "Not equal"
            case .lessThanOrEqual:      comparisonDetail = "Less than or equal"
            case .greaterThanOrEqual:   comparisonDetail = "Greater than or equal"
            case .lessThan:             comparisonDetail = "Less than"
            case .greaterThan:          comparisonDetail = "Greater than"
            default:                    comparisonDetail = "nil:num"
            }
        case .date:
            switch dateComparisonType {
            case .before:   comparisonDetail = "Before"
            case .after:    comparisonDetail = "After"
            default:        comparisonDetail = "nil:date"
            }
        default:
            comparisonDetail = "nil:none"
        }
        
        return
"""
Name:               \(unwrappedName ?? "")
Is satisfied:       \(isSatisfied)
Comparison type:    \(comparisonType?.description ?? "nil")
Comparison detail:  \(comparisonDetail)
Priority type:      \(priorityType)
Left hand:          \(leftHand?.description ?? "nil")
Right hand:         \(rightHand?.description ?? "nil")
"""
    }
}

public extension Condition
{
    var comparisonType: ComparisonType?
    {
        switch (booleanComparisonType, dateComparisonType, numberComparisonType) {
        case (.some, .none, .none):
            return .boolean
        case (.none, .some, .none):
            return .date
        case (.none, .none, .some):
            return .number
        default:
            return nil
        }
    }
    
    var priorityType: Priority
    {
        get {
            Priority(rawValue: priorityTypeRaw) ?? .fallback
        }
        set {
            priorityTypeRaw = newValue.rawValue
        }
    }
    
    var booleanComparisonType: BooleanComparisonType?
    {
        get
        {
            .init(rawValue: booleanComparisonTypeRaw)
        }
        set
        {
            booleanComparisonTypeRaw = newValue?.rawValue ?? -1
        }
    }
    
    var dateComparisonType: DateComparisonType?
    {
        get
        {
            .init(rawValue: dateComparisonTypeRaw)
        }
        set
        {
            dateComparisonTypeRaw = newValue?.rawValue ?? -1
        }
    }
    
    var numberComparisonType: NumberComparisonType?
    {
        get
        {
            .init(rawValue: numberComparisonTypeRaw)
        }
        set
        {
            numberComparisonTypeRaw = newValue?.rawValue ?? -1
        }
    }
}

public extension Condition
{
    var isSatisfied: Bool {
        
        guard let leftHand = leftHand, let rightHand = rightHand else {
            return false
        }
        
        // We can't compare values without the same type
        guard leftHand.valueType == rightHand.valueType else { return false }
        
        if let type = booleanComparisonType
        {
            switch type
            {
            case .equal:
                return leftHand.booleanValue == rightHand.booleanValue
            case .notEqual:
                return leftHand.booleanValue != rightHand.booleanValue
            }
        }
        else if let type = dateComparisonType
        {
            switch type
            {
            case .after:
                return leftHand.dateValue > rightHand.dateValue
            case .before:
                return leftHand.dateValue < rightHand.dateValue
            }
        }
        else if let type = numberComparisonType
        {
            switch type
            {
            case .equal:
                return leftHand.numberValue == rightHand.numberValue
            case .greaterThan:
                return leftHand.numberValue > rightHand.numberValue
            case .greaterThanOrEqual:
                return leftHand.numberValue >= rightHand.numberValue
            case .lessThan:
                return leftHand.numberValue < rightHand.numberValue
            case .lessThanOrEqual:
                return leftHand.numberValue <= rightHand.numberValue
            case .notEqual:
                return leftHand.numberValue != rightHand.numberValue
            }
        }
        else
        {
            fatalError("We don't handle other types, such as `string`.")
        }
    }
}
