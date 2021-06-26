//
//  EventsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class EventsHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Events".localized,
            icon: Icon.event)
        
        disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        
        searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        
        addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
    }
}
