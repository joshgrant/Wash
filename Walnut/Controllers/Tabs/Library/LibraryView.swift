//
//  LibraryView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI

class LibraryView: View<LibraryViewModel>
{
    typealias Delegate = LibraryTableViewDelegateModel
    typealias DataSource = LibraryTableViewDataSourceModel
    
    // MARK: - Variables
    
    var tableView: TableView<Delegate, DataSource, LibraryTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: LibraryViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        
        super.init(model: model)
        
        embed(tableView)
    }
}
