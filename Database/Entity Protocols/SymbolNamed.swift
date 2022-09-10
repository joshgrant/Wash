//
//  SymbolNamed.swift
//  Wash
//
//  Created by Joshua Grant on 9/9/22.
//

import Foundation

protocol SymbolNamed: Named
{
    var symbolName: Symbol? { get set }
}

extension SymbolNamed
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
