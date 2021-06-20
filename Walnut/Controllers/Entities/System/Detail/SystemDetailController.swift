//
//  SystemDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailControllerModel: ControllerModel
{
    // Info
    // Stocks
    // Flows
    // Events
    // Subsystems (what does this even imply?) // subsystems must serve the goal of the parent system
    // Notes
    
    // MARK: - Variables
    
    var system: System
    
    var title: String
    {
        system.title
    }
    
    // MARK: - Initialization
    
    required init(system: System)
    {
        self.system = system
    }
}

class SystemDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: SystemDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SystemDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(system: System)
    {
        let tableViewModel = SystemDetailTableViewModel(system: system)
        self.init(tableViewModel: tableViewModel)
    }
}

class SystemDetailView: View<SystemDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<SystemDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: SystemDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class SystemDetailController: ViewController<
                                SystemDetailControllerModel,
                                SystemDetailViewModel,
                                SystemDetailView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: SystemDetailControllerModel,
        viewModel: SystemDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(system: System)
    {
        let controllerModel = SystemDetailControllerModel(system: system)
        let viewModel = SystemDetailViewModel(system: system)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}

// Table View

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

class SystemDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(system: System)
    {
        let cellModels = Self.makeCellModels(system: system)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(system: System) -> [[TableViewCellModel]]
    {
        [
            [], // Info
            [], // Stocks
            [], // Flows
            [], // Events
            [], // Subsystems
            [] // Notes
        ]
    }
}

// TODO: Genericize the table view model, if you can

class SystemDetailTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(system: System)
    {
        let delegateModel = SystemDetailTableViewDelegateModel(system: system)
        let dataSourceModel = SystemDetailTableViewDataSourceModel(system: system)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegate: .init(model: delegateModel),
            dataSource: .init(model: dataSourceModel),
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            // TODO: Add all of the system detail cells
            TextCellModel.self
        ]
    }
}
