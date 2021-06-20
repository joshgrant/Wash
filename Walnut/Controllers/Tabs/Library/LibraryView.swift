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
    // MARK: - Variables
    
    var tableView: TableView<LibraryTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: LibraryViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        
        super.init(model: model)
        
        embed(tableView)
    }
}
