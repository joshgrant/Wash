//
//  DashboardControllerViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class DashboardViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: DashboardTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: DashboardTableViewModel)
    {
        self.tableViewModel = tableViewModel
        super.init()
    }
    
    convenience init(context: Context)
    {
        let model = DashboardTableViewModel(context: context)
        self.init(tableViewModel: model)
    }
}
