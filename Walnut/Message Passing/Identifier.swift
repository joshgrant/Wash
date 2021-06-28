//
//  Identifier.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct Identifier
{
    var value: String
    
    static let main = Identifier(
        value: "main")
    static let userInterface = Identifier(
        value: "main.userInterface")
    static let stockDetail = Identifier(
        value: "main.stockDetail")
}

extension Identifier: Equatable
{
    static func == (lhs: Identifier, rhs: Identifier) -> Bool
    {
        return lhs.value == rhs.value
    }
}
