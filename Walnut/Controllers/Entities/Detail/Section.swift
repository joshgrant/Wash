//
//  Section.swift
//  Walnut
//
//  Created by Josh Grant on 1/27/22.
//

import Foundation

extension EntityDetailViewController
{
    enum Section: Int, Comparable, CustomStringConvertible
    {
        case info
        case states
        case inflows
        case outflows
        case notes
        case events
        case history
        case conditions
        case flows
        case references
        case links
        
        static func < (lhs: Section, rhs: Section) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        var description: String
        {
            switch self
            {
            case .info:
                return "Info"
            case .states:
                return "\(Icon.state.text) States"
            case .inflows:
                return "\(Icon.leftArrow.text) Inflows"
            case .outflows:
                return "\(Icon.rightArrow.text) Outflows"
            case .notes:
                return "\(Icon.note.text) Notes"
            case .events:
                return "\(Icon.event.text) Events"
            case .history:
                return "\(Icon.forecast.text) History"
            case .conditions:
                return "\(Icon.condition.text) Conditions"
            case .flows:
                return "\(Icon.flow.text) Flows"
            case .references:
                return "References"
            case .links:
                return "Links"
            }
        }
    }
}
