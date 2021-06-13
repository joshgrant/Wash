//
//  SystemListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class SystemListControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var tableViewModel: SystemListTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SystemListTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(context: Context)
    {
        let tableViewModel = SystemListTableViewModel(context: context)
        self.init(tableViewModel: tableViewModel)
    }
}

class SystemListViewModel: ViewModel
{
    
}

class SystemListView: View<SystemListViewModel>
{
    
}

class SystemListTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init()
    {
        let didSelect = Self.makeDidSelect()
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect() -> TableViewSelectionClosure
    {
        { selection in
            // TODO: Take the user to the system detail page
        }
    }
}

class SystemListTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let cellModels = Self.makeCellModels(context: context)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(context: Context) -> [[TableViewCellModel]]
    {
        // TODO: Return a list of all of the system cells
        []
    }
}

class SystemListTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let delegateModel = SystemListTableViewDelegateModel()
        let dataSourceModel = SystemListTableViewDataSourceModel()
        let cellModelTypes = Self.makeCellModelTypes()
        
        super.init(
            style: .grouped,
            delegate: .init(model: delegateModel),
            dataSource: .init(model: dataSourceModel),
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            // TODO: System List Cell
        ]
    }
}

class SystemListController: ViewController<
                                SystemListControllerModel,
                                SystemListViewModel,
                                SystemListView>
{
    // MARK: - Variables
    
    var tableView: TableView<SystemListTableViewModel>
    
    // MARK: - Initialization
    
    required init(
        controllerModel: SystemListControllerModel,
        viewModel: SystemListViewModel)
    {
        tableView = TableView(model: controllerModel.tableViewModel)
    }
}
