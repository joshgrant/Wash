//
//  Symbol+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation
import CoreData

extension Symbol: Named
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
