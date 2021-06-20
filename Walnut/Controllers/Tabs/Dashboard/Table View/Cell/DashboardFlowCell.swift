//
//  DashboardFlowCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation
import ProgrammaticUI

class DashboardFlowCellModel: TableViewCellModel
{
    static var cellClass: AnyClass { DashboardFlowCell.self }
}

class DashboardFlowCell: TableViewCell<DashboardFlowCellModel>
{
    override func configure(with model: DashboardFlowCellModel) {
        
    }
}
