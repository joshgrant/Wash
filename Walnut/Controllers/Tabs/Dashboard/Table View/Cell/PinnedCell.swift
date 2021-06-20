//
//  PinnedCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI

class PinnedCellModel: TableViewCellModel
{
    static var cellClass: AnyClass { PinnedCell.self }
    
    // MARK: - Variables
    
    var title: String
    
    // MARK: - Initialization
    
    init(title: String)
    {
        self.title = title
    }
}

class PinnedCell: TableViewCell<PinnedCellModel>
{
    // MARK: - Variables
    
    
    
    // MARK: - View lifecycle
    
    override func configure(with viewModel: PinnedCellModel)
    {
        
    }
}
