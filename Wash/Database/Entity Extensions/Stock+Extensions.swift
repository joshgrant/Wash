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
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.stock.text
        return "\(icon) \(name)"
    }
}

extension Stock: Printable
{
    var fullDescription: String
    {
"""
Name:       \(unwrappedName ?? "")
Type:       \(typeDescription)
Unit:       \(unitDescription)
Current:    \(currentDescription)
Ideal:      \(idealDescription)
Net:        \(netDescription)
Min:        \(minimumDescription)
Max:        \(maximumDescription)
Inflows:    \(unwrappedInflows)
Outflows:   \(unwrappedOutflows)
Events:     \(unwrappedEvents)
"""
    }
}

extension Stock
{
    var valueType: SourceValueType
    {
        source!.valueType
    }
    
    var unwrappedValidStates: [State]
    {
        get
        {
            validStates?.toArray() ?? []
        }
        set
        {
            validStates = NSSet(array: newValue)
        }
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
    
    // TODO: These descriptions are out of date!
    
    var currentDescription: String
    {
        return String(format: "%.2f", source!.value)
    }
    
    var idealDescription: String
    {
        return String(format: "%.2f", ideal!.value)
    }
    
    var netDescription: String
    {
        // Uses the history to figure out
        // a timeframe and a value
        return "Need to compute"
    }
    
    var minimumDescription: String
    {
        return String(format: "%.2f", minimum!.value)
    }
    
    var maximumDescription: String
    {
        return String(format: "%.2f", maximum!.value)
    }
    
    var unitDescription: String
    {
        guard let unit = unit else
        {
            return "nil"
        }
        
        return unit.description
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
