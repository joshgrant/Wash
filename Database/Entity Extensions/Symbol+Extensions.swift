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
}

extension Symbol
{
    convenience init(context: Context, name: String?)
    {
        self.init(context: context)
        self.name = name
    }
}
