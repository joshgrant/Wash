//
//  SystemDetailFlowsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailFlowsHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Flows".localized,
            icon: Icon.flow)
        
        disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        
        searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        
        addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
    }
}
