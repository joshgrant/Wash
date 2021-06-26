//
//  EventToken.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct MessageToken
{
    var value: String
    
    static let windowVisible = MessageToken(value: "windowVisible")
    static let buttonPress = MessageToken(value: "buttonPress")
    
    struct EntityList
    {
        static let add = MessageToken(value: "entityList.addButton.touchUpInside")
        static let selectedCell = MessageToken(value: "entityList.cell.selected")
        static let pinned = MessageToken(value: "entityList.cell.pinned")
        static let deleted = MessageToken(value: "entityList.cell.deleted")
    }
}

extension MessageToken: Equatable
{
    static func == (lhs: MessageToken, rhs: MessageToken) -> Bool
    {
        lhs.value == rhs.value
    }
}
