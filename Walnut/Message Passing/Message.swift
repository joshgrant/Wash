//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

class Message: Unique, CustomStringConvertible
{
    var id = UUID()
    var timestamp: Date?
}

extension Message
{
    var description: String
    {
        "\(Self.self)"
    }
}
