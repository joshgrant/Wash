//
//  SystemDetailViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: SystemDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SystemDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(system: System)
    {
        let tableViewModel = SystemDetailTableViewModel(system: system)
        self.init(tableViewModel: tableViewModel)
    }
}
