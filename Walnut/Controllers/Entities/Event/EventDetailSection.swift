//
//  EventDetailSection.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import Foundation

enum EventDetailSection: Int, Hashable, Comparable
{
    case info
    case conditions
    case flows
    case history
    
    static func < (lhs: EventDetailSection, rhs: EventDetailSection) -> Bool
    {
        lhs.rawValue < rhs.rawValue
    }
}
