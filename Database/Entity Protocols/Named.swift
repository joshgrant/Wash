//
//  Named.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

public protocol Named: Entity
{
    var unwrappedName: String? { get }
    var managedObjectContext: Context? { get }
}

public extension Named
{
    var title: String
    {
        get {
            unwrappedName ?? ""
        }
    }
}

public protocol SymbolNamed: Named
{
    var symbolName: Symbol? { get set }
}

public extension SymbolNamed
{
    var unwrappedName: String? {
        get {
            symbolName?.name
        }
        set {
            if let name = symbolName {
                name.name = newValue
            } else {
                guard let context = self.managedObjectContext else {
                    assertionFailure("Failed to add the name to the event because the event has no context")
                    return
                }
                
                symbolName = Symbol(context: context, name: newValue)
            }
        }
    }
}
