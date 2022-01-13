//
//  DashboardSection.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation

enum DashboardSection: Int, CaseIterable, Comparable
{
    case pinned
    case suggested
    case forecast
    
    static func < (lhs: DashboardSection, rhs: DashboardSection) -> Bool
    {
        lhs.rawValue < rhs.rawValue
    }
}
