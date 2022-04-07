//
//  Stock+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import CoreData

extension Stock: SymbolNamed {}
extension Stock: Pinnable {}

extension Stock
{
    static let thresholdPercent: Double = 0.6
    
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.stock.text
        
        if percentIdeal.isNaN
        {
            return "\(icon) \(name)"
        }
        else
        {
            let percent = percentIdeal.formatted(.percent)
            return "\(icon) \(name): \(percent)"
        }
    }
}

extension Stock: Printable
{
    var fullDescription: String
    {
"""
Name:           \(unwrappedName ?? "")
Type:           \(typeDescription)
Unit:           \(unitDescription)
Current:        \(currentDescription)
Ideal:          \(idealDescription)
Percent Ideal:  \(percentIdealDescription)
Net:            \(netDescription)
Min:            \(minimumDescription)
Max:            \(maximumDescription)
Inflows:        \(unwrappedInflows)
Outflows:       \(unwrappedOutflows)
Events:         \(unwrappedEvents)
"""
    }
}

extension Stock
{
    var valueType: SourceValueType
    {
        source!.valueType
    }
    
    var unwrappedInflows: [Flow]
    {
        get
        {
            inflows?.toArray() ?? []
        }
        set
        {
            inflows = NSSet(array: newValue)
        }
    }
    
    var unwrappedOutflows: [Flow]
    {
        get
        {
            outflows?.toArray() ?? []
        }
        set
        {
            outflows = NSSet(array: newValue)
        }
    }
    
    var unwrappedEvents: [Event]
    {
        get
        {
            events?.toArray() ?? []
        }
        set
        {
            events = NSSet(array: newValue)
        }
    }
}

extension Stock
{
    var typeDescription: String
    {
        return valueType.description
    }
    
    var currentDescription: String
    {
        return current.formatted(.number.precision(.fractionLength(2)))
    }
    
    var idealDescription: String
    {
        return target.formatted(.number.precision(.fractionLength(2)))
    }
    
    var netDescription: String
    {
        // Uses the history to figure out
        // a timeframe and a value
        return "Need to compute"
    }
    
    var minimumDescription: String
    {
        return min.formatted(.number.precision(.fractionLength(2)))
    }
    
    var maximumDescription: String
    {
        return max.formatted(.number.precision(.fractionLength(2)))
    }
    
    var unitDescription: String
    {
        guard let unit = unit else
        {
            return "nil"
        }
        
        return unit.description
    }
    
    var percentIdealDescription: String
    {
        return percentIdeal.formatted(.percent.precision(.fractionLength(2)))
    }
}

extension Stock
{
    var current: Double
    {
        get { source!.value }
        set { source!.value = newValue }
    }
    
    var target: Double
    {
        get { ideal!.value }
        set { ideal!.value = newValue }
    }
    
    var min: Double
    {
        get { minimum!.value }
        set { minimum!.value = newValue }
    }
    
    var max: Double
    {
        get { maximum!.value }
        set { maximum!.value = newValue }
    }
    
    public var percentIdeal: Double
    {
        return Double.percentDelta(
            a: current,
            b: target,
            minimum: min,
            maximum: max)
    }
}

extension Stock: Comparable
{
    public static func < (lhs: Stock, rhs: Stock) -> Bool
    {
        (lhs.unwrappedName ?? "") < (rhs.unwrappedName ?? "")
    }
}
