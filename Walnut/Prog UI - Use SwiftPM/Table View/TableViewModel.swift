//
//  TableViewModel.swift
//  
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public struct TableViewModel
{
    var style: UITableView.Style = .grouped
    
    var delegate: TableViewDelegate
    var dataSource: TableViewDataSource
    
    var cellModelTypes: [TableViewCellModel.Type]
}
