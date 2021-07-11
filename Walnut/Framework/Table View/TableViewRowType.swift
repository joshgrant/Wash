//
//  TableViewRowType.swift
//  Walnut
//
//  Created by Joshua Grant on 7/10/21.
//

import Foundation

class TableViewRowType
{
    class Title:  { }
    
    static let title = TableViewRowType(rawValue: 0)
    static let from = TableViewRowType(rawValue: 1)
    static let to = TableViewRowType(rawValue: 2)
    static let amount = TableViewRowType(rawValue: 3)
    static let duration = TableViewRowType(rawValue: 4)
    static let requiresUserCompletion = TableViewRowType(rawValue: 5)
    static let event = TableViewRowType(rawValue: -1)
    static let history = TableViewRowType(rawValue: -1)
}
