//
//  ListSection.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation

struct ListSection: Hashable
{
    // MARK: - Variables
    
    var title: String
    var icon: Icon?
    
    var search: ActionClosure?
    var link: ActionClosure?
    var add: ActionClosure?
    var edit: ActionClosure?
    
    var hasDisclosure: Bool
    
    var hasSearch: Bool { search != nil }
    var hasLink: Bool { link != nil }
    var hasAdd: Bool { add != nil }
    var hasEdit: Bool { edit != nil }
    
    // MARK: - Initialization
    
    init(title: String, icon: Icon? = nil, hasDisclosure: Bool = false)
    {
        self.title = title
        self.icon = icon
        self.hasDisclosure = hasDisclosure
    }
}

extension ListSection
{
    static let info = ListSection(title: .info)
    static let events = ListSection(title: .events)
    static let history = ListSection(title: .history)
    static let pinned = ListSection(title: .pinned, icon: .pin)
    static let flows = ListSection(title: .flows, icon: .flow)
    static let forecast = ListSection(title: .forecast, icon: .forecast)
    static let priority = ListSection(title: .priority, icon: .priority)
    static let valueType = ListSection(title: .valueType)
    static let transitionType = ListSection(title: .transitionType)
    static let references = ListSection(title: .references)
    static let links = ListSection(title: .links)
    static let ideal = ListSection(title: .ideal)
    static let current = ListSection(title: .current)
    static let stateMachine = ListSection(title: .states)
    static let constraints = ListSection(title: .constraints)
    static let goal = ListSection(title: .goal)
}
