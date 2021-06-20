//
//  SystemListTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import CoreData
import ProgrammaticUI

class SystemListTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let cellModels = Self.makeCellModels(context: context)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(context: Context) -> [[TableViewCellModel]]
    {
        [
            makeSystemsListCellModels(context: context)
        ]
    }
    
    static func makeSystemsListCellModels(context: Context) -> [TableViewCellModel]
    {
        System
            .allSystems(context: context)
            .map
            {
                TextCellModel(title: $0.title, disclosureIndicator: true)
            }
    }
}
