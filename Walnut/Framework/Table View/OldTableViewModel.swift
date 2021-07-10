//
//  OldTableViewModel.swift
//  
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class OldTableViewModel: ViewModel
{
    // MARK: - Variables
    
    public var style: UITableView.Style = .grouped
    
    public var delegate: TableViewDelegate
    public var dataSource: TableViewDataSource
    
    public var cellModelTypes: [TableViewCellModel.Type]
    
    // MARK: - Initialization
    
    public init(
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
