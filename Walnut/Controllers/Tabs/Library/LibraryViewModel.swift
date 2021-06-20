//
//  LibraryControllerViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI

class LibraryViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: LibraryTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: LibraryTableViewModel)
    {
        self.tableViewModel = tableViewModel
        super.init()
    }
    
    convenience init(context: Context)
    {
        let model = LibraryTableViewModel(context: context)
        self.init(tableViewModel: model)
    }
}
