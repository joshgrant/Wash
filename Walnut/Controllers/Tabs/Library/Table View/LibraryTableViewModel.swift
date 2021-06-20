//
//  LibraryTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class LibraryTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: UINavigationController)
    {
        let delegateModel = LibraryTableViewDelegateModel(context: context, navigationController: navigationController)
        let dataSourceModel = LibraryTableViewDataSourceModel(context: context)
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
        [LibraryCellModel.self]
    }
}
