//
//  PinnedCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class PinnedCellModel: TableViewCellModel
{
    static var cellClass: AnyClass { PinnedCell.self }
}

class PinnedCell: TableViewCell<PinnedCellModel>
{
    override func configure(with viewModel: PinnedCellModel)
    {
        
    }
}
