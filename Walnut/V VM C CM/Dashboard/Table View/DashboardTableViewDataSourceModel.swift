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
        let cellModels = Self.makeCellModels()
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels() -> [[TableViewCellModel]]
    {
        [
            [
                PinnedCellModel()
            ],
            [
                PinnedCellModel() // Flows
            ],
            [
                PinnedCellModel() // Events
            ],
            [
                PinnedCellModel() // Priority Systems
            ]
        ]
    }
}
