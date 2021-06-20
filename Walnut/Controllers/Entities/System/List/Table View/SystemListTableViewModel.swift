//
//  SystemListTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import ProgrammaticUI

//class SystemListTableViewModel: TableViewModel
//{
//    // MARK: - Initialization
//    
//    convenience init(context: Context, navigationController: NavigationController)
//    {
//        let delegateModel = SystemListTableViewDelegateModel(context: context, navigationController: navigationController)
//        let dataSourceModel = SystemListTableViewDataSourceModel(context: context)
//        let cellModelTypes = Self.makeCellModelTypes()
//        
//        self.init(
//            style: .grouped,
//            delegate: .init(model: delegateModel),
//            dataSource: .init(model: dataSourceModel),
//            cellModelTypes: cellModelTypes)
//    }
//    
//    // MARK: - Factory
//    
//    static func makeCellModelTypes() -> [TableViewCellModel.Type]
//    {
//        [
//            TextCellModel.self
//        ]
//    }
//}
