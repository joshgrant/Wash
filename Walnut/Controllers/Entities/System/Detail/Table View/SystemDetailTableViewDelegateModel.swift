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
    
    convenience init(system: System, navigationController: NavigationController, stateMachine: EntityListStateMachine)
    {
        let headerViews = Self.makeHeaderViews(system: system, navigationController: navigationController, stateMachine: stateMachine)
        
        // TODO: Add a selection action closure
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44},
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(system: System, navigationController: NavigationController, stateMachine: EntityListStateMachine) -> [TableHeaderViewModel]
    {
        [
            InfoHeaderViewModel(),
            StocksHeaderViewModel(system: system, navigationController: navigationController, stateMachine: stateMachine),
            SystemDetailFlowsHeaderViewModel(),
            EventsHeaderViewModel(),
            SubSystemsHeaderViewModel(),
            NotesHeaderViewModel()
        ]
    }
    
    static func makeHeaderViews(system: System, navigationController: NavigationController, stateMachine: EntityListStateMachine) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(system: system, navigationController: navigationController, stateMachine: stateMachine)
        return models.map { TableHeaderView(model: $0) }
    }
}
