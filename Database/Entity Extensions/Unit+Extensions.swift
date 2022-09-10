//
//  Unit+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

extension Unit: SymbolNamed {}

extension Unit
{
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.unit.text
        return "\(icon) \(name)"
    }
}

extension Unit: Insertable
{
    typealias T = Unit
    
    static func insert(name: String, into context: Context) -> Unit
    {
        let unit = Unit(context: context)
        unit.isBase = true
        unit.unwrappedName = name
        unit.abbreviation = name
        return unit
    }
}
