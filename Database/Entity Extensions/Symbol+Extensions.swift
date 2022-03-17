//
//  Symbol+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation
import CoreData

extension Symbol: SymbolNamed
{
    public var symbolName: Symbol?
    {
        get {
            return self
        }
        set {
            fatalError("Should never do this")
        }
    }
    
    public var reference: Entity?
    {
        if let color = nameOfColor
        {
            return color
        }
        else if let condition = nameOfCondition
        {
            return condition
        }
        else if let conversion = nameOfConversion
        {
            return conversion
        }
        else if let event = nameOfEvent
        {
            return event
        }
        else if let flow = nameOfFlow
        {
            return flow
        }
        else if let state = nameOfState
        {
            return state
        }
        else if let stock = nameOfStock
        {
            return stock
        }
        else if let task = nameOfTask
        {
            return task
        }
        else if let unit = nameOfUnit
        {
            return unit
        }
        else
        {
            return nil
        }
    }
}
//extension Symbol: Listable {}

extension Symbol: Searchable
{
    public static func predicate(for queryString: String) -> NSPredicate
    {
        makeNamePredicate(queryString)
    }
    
    private static func makeNamePredicate(_ queryString: String) -> NSPredicate
    {
        NSPredicate(format: "name CONTAINS[cd] %@", queryString)
    }
}

extension Symbol
{
    convenience init(context: Context, name: String?)
    {
        self.init(context: context)
        self.name = name
    }
}
