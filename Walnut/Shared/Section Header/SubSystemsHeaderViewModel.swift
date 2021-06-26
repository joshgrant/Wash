//
//  SubSystemsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class SubSystemsHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Subsystems".localized,
            icon: Icon.system)
        
        disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        
        searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        
        addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
    }
}
