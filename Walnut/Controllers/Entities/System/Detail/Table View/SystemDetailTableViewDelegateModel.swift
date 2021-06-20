//
//  SystemDetailTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(system: System)
    {
        let headerViews = Self.makeHeaderViews()
        
        // TODO: Add a selection action closure
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44},
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels() -> [TableHeaderViewModel]
    {
        [
            InfoHeaderViewModel(),
            StocksHeaderViewModel(),
            SystemDetailFlowsHeaderViewModel(),
            EventsHeaderViewModel(),
            SubSystemsHeaderViewModel(),
            NotesHeaderViewModel()
        ]
    }
    
    static func makeHeaderViews(models: [TableHeaderViewModel]? = nil) -> [TableHeaderView]
    {
        let models = models ?? makeHeaderViewModels()
        return models.map { TableHeaderView(model: $0) }
    }
}
