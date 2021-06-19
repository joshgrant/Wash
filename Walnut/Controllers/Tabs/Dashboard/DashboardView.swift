//
//  DashboardView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class DashboardView: View<DashboardViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<DashboardTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: DashboardViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        
        super.init(model: model)
        
        embed(tableView)
    }
}
