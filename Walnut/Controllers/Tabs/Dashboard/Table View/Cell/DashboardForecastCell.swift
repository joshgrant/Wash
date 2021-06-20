//
//  DashboardForecastCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation
import ProgrammaticUI

class DashboardForecastCellModel: TableViewCellModel
{
    static var cellClass: AnyClass { DashboardForecastCell.self }
}

class DashboardForecastCell: TableViewCell<DashboardForecastCellModel>
{
    override func configure(with model: DashboardForecastCellModel) {
        
    }
}
