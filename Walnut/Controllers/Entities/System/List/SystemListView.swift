//
//  SystemListView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import ProgrammaticUI

class SystemListView: View<SystemListViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<SystemListTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: SystemListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}
