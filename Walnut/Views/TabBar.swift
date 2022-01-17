//
//  TabBar.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation

class TabBar: View
{
    var tabs: [View]
    var activeTab: View
    
    init(tabs: [View], activeTab: View? = nil)
    {
        precondition(tabs.count > 0)
        self.tabs = tabs
        self.activeTab = activeTab ?? tabs.first!
    }
    
    func display()
    {
        activeTab.display()
    }
    
    func handle(input: String)
    {
        switch input
        {
        case "dashboard":
            activeTab = tabs.first!
        case "library":
            activeTab = tabs.last!
        default:
            activeTab.handle(input: input)
        }
    }
    
    func handle(section: Int?, row: Int?, command: String?)
    {
        activeTab.handle(section: section, row: row, command: command)
    }
}
