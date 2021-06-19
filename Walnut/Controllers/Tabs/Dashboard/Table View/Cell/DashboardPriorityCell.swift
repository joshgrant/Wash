//
//  DashboardPriorityCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation

class DashboardPriorityCellModel: TableViewCellModel
{
    static var cellClass: AnyClass { DashboardPriorityCell.self }
}

class DashboardPriorityCell: TableViewCell<DashboardPriorityCellModel>
{
    override func configure(with model: DashboardPriorityCellModel) {
        
    }
}
