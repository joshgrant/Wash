//
//  Condition+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation

extension Condition: SymbolNamed {}

public extension Condition
{
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
    
//    var stringComparisonType: StringComparisonType?
//    {
//        get
//        {
//            .init(rawValue: stringComparisonTypeRaw)
//        }
//        set
//        {
//            stringComparisonTypeRaw = newValue?.rawValue ?? -1
//        }
//    }
}

public extension Condition
{
    var unwrappedEvents: Set<Event> {
        guard let unwrapped = events as? Set<Event> else {
            assertionFailure("Failed to unwrap the events NSSet to an [Event]")
            return []
        }
        
        return unwrapped
    }
}

public extension Condition
{
    var isSatisfied: Bool {
        
        let leftHand = leftHand!
        let rightHand = rightHand!
        
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

public enum ConditionError: Error
{
    case invalidType(given: Any, expected: Any)
    case invalidComparison
}
