//
//  TableViewSectionType.swift
//  Walnut
//
//  Created by Joshua Grant on 7/10/21.
//

import Foundation

@dynamicMemberLookup
struct TableViewSectionType:
    Unique,
    RawRepresentable,
    ExpressibleByStringLiteral,
    CustomStringConvertible
{
    typealias StringLiteralType = String
    
    var id = UUID()
    var rawValue: Int
    var stringValue: String
    
    @available(*, renamed: "init")
    init(rawValue: Int)
    {
        fatalError("Do not call")
    }
    
    @available(*, renamed: "init")
    init(stringLiteral value: String)
    {
        fatalError("Do not call")
    }
    
    init(rawValue: Int, stringLiteral value: String)
    {
        self.rawValue = rawValue
        self.stringValue = value
    }
    
    func callAsFunction() -> Int
    {
        return rawValue
    }
    
    var description: String
    {
        return stringValue
    }
    
    static subscript(dynamicMember member: TableViewSectionType) -> Int
    {
        switch member
        {
        case .info: return info.rawValue
        case .events: return events.rawValue
        case .history: return history.rawValue
        default:
            assertionFailure("Dynamic member lookup failed")
            return -1
        }
    }
    
    private static let info = TableViewSectionType(rawValue: 0, stringLiteral: "info")
    private static let events = TableViewSectionType(rawValue: 1, stringLiteral: "events")
    private static let history = TableViewSectionType(rawValue: 2, stringLiteral: "history")
}
