//
//  SystemDetailTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(system: System, navigationController: NavigationController)
    {
        let delegateModel = SystemDetailTableViewDelegateModel(system: system, navigationController: navigationController)
        let dataSourceModel = SystemDetailTableViewDataSourceModel(system: system)
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
            // TODO: Add all of the system detail cells
            TextEditCellModel.self,
            TextCellModel.self,
            IdealInfoCellModel.self,
            SuggestedFlowCellModel.self,
            DetailCellModel.self
            // Title cell
            // Ideal cell
            // Suggested flows
            // Stock cell
            // Flow (detail bottom + right)
            // event cell (detail)
            // System cell (detail)
            // Note cell (detail)
        ]
    }
}
