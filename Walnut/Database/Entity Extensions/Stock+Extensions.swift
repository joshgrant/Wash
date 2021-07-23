//
//  Stock+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation

extension Stock: Named {}
extension Stock: Pinnable {}

extension Stock
{
    public override func awakeFromInsert()
    {
        super.awakeFromInsert()
        
        guard let context = managedObjectContext else { fatalError() }
        
        let source = Source(context: context)
        source.value = 0
        source.valueType = .number
        self.source = source
        
        let ideal = Source(context: context)
        ideal.value = 0
        ideal.valueType = .number
        self.ideal = ideal
        
        let minimum = Source(context: context)
        minimum.value = 0
        minimum.valueType = .number
        self.minimum = minimum
        
        let maximum = Source(context: context)
        maximum.value = 0
        maximum.valueType = .number
        self.maximum = maximum
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
