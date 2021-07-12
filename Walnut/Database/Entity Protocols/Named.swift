//
//  Named.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

public typealias NamedEntity = Entity & Named

public protocol Named: Entity
{
    var symbolName: Symbol? { get set }
    var unwrappedName: String? { get set }
    var managedObjectContext: Context? { get }
}

public extension Named
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
    
    var title: String
    {
        get {
            unwrappedName ?? ""
        }
        set {
            unwrappedName = newValue
        }
    }
}
