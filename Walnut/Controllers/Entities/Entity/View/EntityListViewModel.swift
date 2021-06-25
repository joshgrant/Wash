//
//  EntityListViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListViewModel: ViewModel
{
    // MARK: - Variables
    
    private var entityType: Entity.Type
    
    var tableViewModel: EntityListTableViewModel
    
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    var title: String { entityType.readableName.pluralize() }
    
    // MARK: - Initialization
    
    init(tableViewModel: EntityListTableViewModel, entityType: Entity.Type)
    {
        self.tableViewModel = tableViewModel
        self.entityType = entityType
    }
    
    convenience init(context: Context, navigationController: NavigationController, entityType: Entity.Type)
    {
        let tableViewModel = EntityListTableViewModel(
            context: context,
            navigationController: navigationController,
            entityType: entityType)
        self.init(tableViewModel: tableViewModel, entityType: entityType)
    }
}
