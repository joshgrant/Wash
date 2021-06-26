//
//  DashboardTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class DashboardTableViewDelegateModel: TableViewDelegateModel
{
    convenience init()
    {
        let headerViews = Self.makeHeaderViews()
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: nil,
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViews() -> [TableHeaderView]
    {
        // TODO: This should be re-arrangeable in settings
        let headerModels = [
            PinnedHeaderViewModel(),
            FlowsHeaderViewModel(),
            ForecastHeaderViewModel(),
            PriorityHeaderViewModel()
        ]
        
        return headerModels.map { TableHeaderView(model: $0) }
    }
}
