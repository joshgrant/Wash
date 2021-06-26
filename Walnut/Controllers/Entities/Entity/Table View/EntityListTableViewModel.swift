//
//  EntityListTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class EntityListTableViewModel: TableViewModel
{
    convenience init(context: Context, navigationController: NavigationController, entityType: Entity.Type)
    {
        let delegateModel = EntityListTableViewDelegateModel(
            context: context,
            navigationController: navigationController, type: entityType)
        let delegate = EntityListTableViewDelegate(model: delegateModel, entityType: entityType, context: context)
        let dataSourceModel = EntityListTableViewDataSourceModel(
            context: context,
            type: entityType)
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
