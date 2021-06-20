//
//  SystemListViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import ProgrammaticUI

class SystemListViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: SystemListTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SystemListTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let tableViewModel = SystemListTableViewModel(context: context, navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}
