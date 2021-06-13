//
//  DashboardTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class DashboardTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init()
    {
        let delegateModel = DashboardTableViewDelegateModel()
        let dataSourceModel = DashboardTableViewDataSourceModel()
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegate: .init(model: delegateModel),
            dataSource: .init(model: dataSourceModel),
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            PinnedCellModel.self
            // TODO:
            // Flow Cell
            // Event Cell
            // System Cell
        ]
    }
}
