//
//  SectionHeader.swift
//  Center
//
//  Created by Joshua Grant on 5/29/21.
//

import UIKit

//enum SectionHeader: Int
//{
//    case info
//    case suggestedFlows
//    case stocks
//    case flows
//    case events
//    case notes
//    case history
//    case pinned
//    case forecast
//    case priority
//    case states
//    case inflows
//    case outflows
//
//    static var systemDetail: [SectionHeader]
//    {
//        [
//            .info, .stocks, .flows, .events, .notes
//        ]
//    }
//
//    static var flowDetail: [SectionHeader]
//    {
//        [
//            .info, .events, .history, .notes
//        ]
//    }
//
//    static var dashboard: [SectionHeader]
//    {
//        [
//            .pinned, .flows, .forecast, .priority
//        ]
//    }
//
//    static var stockDetail: [SectionHeader]
//    {
//        [
//            .info, .states, .inflows, .outflows, .events, .notes
//        ]
//    }
//
//    var title: String
//    {
//        switch self
//        {
//        case .info: return "Info"
//        case .suggestedFlows: return "Suggested Flows"
//        case .stocks: return "Stocks"
//        case .flows: return "Flows"
//        case .events: return "Events"
//        case .notes: return "Notes"
//        case .history: return "History"
//        case .pinned: return "Pinned"
//        case .forecast: return "Forecast"
//        case .priority: return "Priority"
//        case .states: return "States"
//        case .inflows: return "Inflows"
//        case .outflows: return "Outflows"
//        }
//    }
//
//    var icon: Icon?
//    {
//        switch self
//        {
//        case .info, .suggestedFlows: return nil
//        case .stocks: return .stock
//        case .flows: return .flow
//        case .events: return .event
//        case .notes: return .note
//        case .pinned: return .pinFill
//        case .forecast: return .forecast
//        case .priority: return .priority
//        case .history: return nil
//        case .states: return .state
//        case .inflows: return nil
//        case .outflows: return nil
//        }
//    }
//
//    var hasDisclosureTriangle: Bool
//    {
//        switch self
//        {
//        case .events, .notes, .states, .stocks, .flows:
//            return true
//        default:
//            return false
//        }
//    }
//
//    var hasSearchButton: Bool
//    {
//        switch self
//        {
//        case .events:
//            return true
//        default:
//            return false
//        }
//    }
//
//    var hasLinkButton: Bool
//    {
//        switch self
//        {
//        case .notes, .events:
//            return true
//        default:
//            return false
//        }
//    }
//
//    var hasAddButton: Bool
//    {
//        switch self
//        {
//        case .stocks, .events, .notes, .flows:
//            return true
//        default:
//            return false
//        }
//    }
//
//    var hasEditButton: Bool
//    {
//        switch self
//        {
//        case .states:
//            return true
//        default:
//            return false
//        }
//    }
//}
