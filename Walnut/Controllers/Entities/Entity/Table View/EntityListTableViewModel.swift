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
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type, stateMachine: EntityListStateMachine)
    {
        let delegateModel = EntityListTableViewDelegateModel(
            context: context,
            navigationController: navigationController, type: type, stateMachine: stateMachine)
        let delegate = EntityListTableViewDelegate(model: delegateModel, entityType: type, context: context)
        let dataSourceModel = EntityListTableViewDataSourceModel(
            context: context,
            type: type)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegate: delegate,
            dataSource: .init(model: dataSourceModel),
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
