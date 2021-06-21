//
//  EntityListTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class EntityListTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, type: Entity.Type)
    {
        let cellModels = Self.makeCellModels(context: context, type: type)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(context: Context, type: Entity.Type) -> [[TableViewCellModel]]
    {
        [
            makeEntityListCellModels(context: context, type: type)
        ]
    }
    
    static func makeEntityListCellModels(context: Context, type: Entity.Type) -> [TableViewCellModel]
    {
        type
            .all(context: context)
            .compactMap { $0 as? Named }
            .map { TextCellModel(title: $0.title, disclosureIndicator: true) }
    }
}
