//
//  EntityListViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class EntityListViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: EntityListTableViewModel
    
    // MARK: - Initialization
    
    init(tableViewModel: EntityListTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type, stateMachine: EntityListStateMachine)
    {
        let tableViewModel = EntityListTableViewModel(
            context: context,
            navigationController: navigationController, type: type, stateMachine: stateMachine)
        self.init(tableViewModel: tableViewModel)
    }
}
