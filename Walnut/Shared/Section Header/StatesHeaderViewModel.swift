//
//  StatesHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class StatesHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init()
    {
        self.init(
            title: "States".localized,
            icon: .state)
        
        disclosureTriangleActionClosure = ActionClosure { sender in
            print("Disclose!")
        }
        
        editButtonActionClosure = ActionClosure { sender in
            print("Edit the states list")
        }
    }
}
