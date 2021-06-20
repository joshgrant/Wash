//
//  SystemDetailView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailView: View<SystemDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<SystemDetailTableViewDelegateModel, SystemDetailTableViewDataSourceModel, SystemDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: SystemDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}
