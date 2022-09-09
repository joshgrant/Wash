//
//  EntityFormatStyle.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation

struct EntityFormatStyle: FormatStyle
{
    typealias FormatInput = Entity
    typealias FormatOutput = String
    
    func format(_ value: Entity) -> String {
        return value.debugDescription
    }
}
