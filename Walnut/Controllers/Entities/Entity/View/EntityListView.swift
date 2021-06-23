//
//  EntityListView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class EntityListView: View<EntityListViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<EntityListTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: EntityListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}
