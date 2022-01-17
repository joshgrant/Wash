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
        let icon = Icon.stock.textIcon()
        return "\(icon) \(name)"
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
}

extension Stock
{
    var current: Double { source!.value }
    var target: Double { ideal!.value }
    var min: Double { minimum!.value }
    var max: Double { maximum!.value }
    
    public var percentIdeal: Double
    {
        return Double.percentDelta(
            a: current,
            b: target,
            minimum: min,
            maximum: max)
    }
}
