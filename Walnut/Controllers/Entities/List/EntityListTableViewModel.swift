//
//  EntityListTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class EntityListTableViewModel: TableViewModel
{
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let delegateModel = EntityListTableViewDelegateModel(
            context: context,
            navigationController: navigationController, type: type)
        let dataSourceModel = EntityListTableViewDataSourceModel(
            context: context,
            type: type)
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
            TextCellModel.self
        ]
    }
}
