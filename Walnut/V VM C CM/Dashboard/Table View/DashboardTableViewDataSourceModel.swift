//
//  DashboardTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class DashboardTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init()
    {
        self.init(cellModels: [[PinnedCellModel()]])
    }
}
