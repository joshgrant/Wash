//
//  SystemDetailViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class SystemDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: SystemDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SystemDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(system: System, navigationController: NavigationController, delegate: UITextFieldDelegate)
    {
        let tableViewModel = SystemDetailTableViewModel(
            system: system,
            navigationController: navigationController,
            delegate: delegate)
        self.init(tableViewModel: tableViewModel)
    }
}
