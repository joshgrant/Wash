//
//  EventToken.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct EventToken
{
    var value: String
    
    static let windowVisible = EventToken(value: "windowVisible")
    static let buttonPress = EventToken(value: "buttonPress")
}

extension EventToken: Equatable
{
    static func == (lhs: EventToken, rhs: EventToken) -> Bool
    {
        lhs.value == rhs.value
    }
}
