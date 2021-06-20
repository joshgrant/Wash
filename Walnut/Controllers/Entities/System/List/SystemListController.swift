//
//  SystemListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI
import CoreData

class SystemListControllerModel: ControllerModel
{
}

class SystemListViewModel: ViewModel
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

class SystemListView: View<SystemListViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<SystemListTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: SystemListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
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
            print("Did select system list at: \(selection.indexPath)")
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
        [
            makeSystemsListCellModels(context: context)
        ]
    }
    
    static func makeSystemsFetchRequest() -> NSFetchRequest<System>
    {
        let fetchRequest: NSFetchRequest<System> = System.fetchRequest()
        return fetchRequest
    }
    
    static func getSystems(context: Context) -> [System]
    {
        let request = makeSystemsFetchRequest()
        do
        {
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    static func makeSystemsListCellModels(context: Context) -> [TableViewCellModel]
    {
        let systems = getSystems(context: context)
        return systems.map
        {
            TextCellModel(title: $0.title, disclosureIndicator: true)
        }
    }
}

class SystemListTableViewModel: TableViewModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let delegateModel = SystemListTableViewDelegateModel()
        let dataSourceModel = SystemListTableViewDataSourceModel(context: context)
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
            TextCellModel.self
        ]
    }
}

class SystemListController: ViewController<
                                SystemListControllerModel,
                                SystemListViewModel,
                                SystemListView>
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let controllerModel = SystemListControllerModel()
        let viewModel = SystemListViewModel(context: context)
        self.init(controllerModel: controllerModel, viewModel: viewModel)
    }
}
