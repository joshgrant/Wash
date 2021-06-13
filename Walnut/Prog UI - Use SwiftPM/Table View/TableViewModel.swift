//
//  TableViewModel.swift
//  
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public class TableViewModel: ViewModel
{
    // MARK: - Variables
    
    var style: UITableView.Style = .grouped
    
    var delegate: TableViewDelegate
    var dataSource: TableViewDataSource
    
    var cellModelTypes: [TableViewCellModel.Type]
    
    // MARK: - Initialization
    
    init(
        style: UITableView.Style,
        delegate: TableViewDelegate,
        dataSource: TableViewDataSource,
        cellModelTypes: [TableViewCellModel.Type])
    {
        self.style = style
        self.delegate = delegate
        self.dataSource = dataSource
        self.cellModelTypes = cellModelTypes
    }
}
