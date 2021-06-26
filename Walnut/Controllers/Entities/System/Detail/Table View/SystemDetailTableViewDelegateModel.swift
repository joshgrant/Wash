//
//  SystemDetailTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class SystemDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(system: System, navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(system: system, navigationController: navigationController)
        
        // TODO: Add a selection action closure
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44},
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(system: System, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
            InfoHeaderViewModel(),
            StocksHeaderViewModel(system: system, navigationController: navigationController),
            SystemDetailFlowsHeaderViewModel(),
            EventsHeaderViewModel(),
            SubSystemsHeaderViewModel(),
            NotesHeaderViewModel()
        ]
    }
    
    static func makeHeaderViews(system: System, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(system: system, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}
