//
//  EntityListFormatStyle.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation

struct EntityListFormatStyle: FormatStyle
{
    typealias FormatInput = [Entity]
    typealias FormatOutput = String

    func format(_ value: [Entity]) -> String
    {
        var output = "["
        
        // TODO: Maybe with indexes is an option?
        for item in value.enumerated()
        {
            output += "\(item.offset): \(EntityFormatStyle().format(item.element)), "
        }
        
        if output.count > 2 {
            output.removeLast(2)
        }
        
        output += "]"
        
        return output
    }
}
