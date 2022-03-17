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
