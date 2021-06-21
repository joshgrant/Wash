//
//  DashboardTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit
import ProgrammaticUI

class DashboardTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let delegateModel = DashboardTableViewDelegateModel()
        let dataSourceModel = DashboardTableViewDataSourceModel(context: context)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegateModel: delegateModel,
            dataSourceModel: dataSourceModel,
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            PinnedCellModel.self,
            TextCellModel.self,
            DetailCellModel.self
            // TODO:
            // Flow Cell
            // Event Cell
            // System Cell
        ]
    }
}
