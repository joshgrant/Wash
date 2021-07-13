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
        
        let value = ValueSource(context: context)
        value.value = 0
        amount = value
        
        let idealValue = ValueSource(context: context)
        idealValue.value = 0
        ideal = idealValue
        
        let minimumValue = ValueSource(context: context)
        minimumValue.value = 0
        minimum = minimumValue
        
        let maximumValue = ValueSource(context: context)
        maximumValue.value = 0
        maximum = maximumValue
    }
}

extension Stock
{
    var amountType: AmountType
    {
        get
        {
            AmountType(rawValue: amountTypeRaw) ?? .fallback
        }
        set
        {
            amountTypeRaw = newValue.rawValue
        }
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
    //    var currentValue: Any? { amount?.computedValue }
    //    var idealValue: Any? { ideal?.computedValue }
    
    var amountValue: Double
    {
        get
        {
            switch amount
            {
            case let s as ValueSource:
                return s.value
            case is InfiniteSource:
                return Double.infinity
            default:
                fatalError("Unhandled source")
            }
        }
        set
        {
            guard let context = self.managedObjectContext else { return }
            let valueSource = ValueSource(context: context)
            valueSource.value = newValue
            self.amount = valueSource
        }
    }
    
    var idealValue: Double
    {
        get
        {
            switch ideal
            {
            case let s as ValueSource:
                return s.value
            case is InfiniteSource:
                return Double.infinity
            default:
                fatalError("Unhandled source")
            }
        }
        set
        {
            guard let context = self.managedObjectContext else { return }
            let valueSource = ValueSource(context: context)
            valueSource.value = newValue
            self.ideal = valueSource
        }
    }
    
    var minimumValue: Double
    {
        get
        {
            switch minimum
            {
            case let s as ValueSource:
                return s.value
            case is InfiniteSource:
                return -Double.infinity
            default:
                fatalError("Unhandled source")
            }
        }
        set
        {
            guard let context = self.managedObjectContext else { return }
            let valueSource = ValueSource(context: context)
            valueSource.value = newValue
            self.minimum = valueSource
        }
    }
    
    var maximumValue: Double
    {
        get
        {
            switch maximum
            {
            case let s as ValueSource:
                return s.value
            case is InfiniteSource:
                return Double.infinity
            default:
                fatalError("Unhandled source")
            }
        }
        set
        {
            guard let context = self.managedObjectContext else { return }
            let valueSource = ValueSource(context: context)
            valueSource.value = newValue
            self.maximum = valueSource
        }
    }
}

extension Stock
{
    var typeDescription: String
    {
        return amountType.description
    }
    
    var dimensionDescription: String
    {
        return dimension?.title ?? "None"
    }
    
    var currentDescription: String
    {
        return String(format: "%.2f", amountValue)
    }
    
    var idealDescription: String
    {
        return String(format: "%.2f", idealValue)
    }
    
    var netDescription: String
    {
        // Uses the history to figure out
        // a timeframe and a value
        return "Need to compute"
    }
    
    var minimumDescription: String
    {
        return String(format: "%.2f", minimumValue)
    }
    
    var maximumDescription: String
    {
        return String(format: "%.2f", maximumValue)
    }
}
