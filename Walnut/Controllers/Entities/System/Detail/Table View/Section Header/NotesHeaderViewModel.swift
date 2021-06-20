//
//  NotesHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class NotesHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Notes".localized,
            icon: Icon.note)
        
        disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        
        searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        
        addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
    }
}
