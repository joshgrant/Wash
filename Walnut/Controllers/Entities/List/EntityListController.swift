//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit
import ProgrammaticUI

class EntityListViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: EntityListTableViewModel
    
    // MARK: - Initialization
    
    init(tableViewModel: EntityListTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let tableViewModel = EntityListTableViewModel(
            context: context,
            navigationController: navigationController, type: type)
        self.init(tableViewModel: tableViewModel)
    }
}

class EntityListView: View<EntityListViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<EntityListTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: EntityListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class EntityListControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var addAction: ActionClosure
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        addAction = Self.makeAddAction(
            context: context,
            navigationController: navigationController,
            type: type)
    }
    
    // MARK: - Factory
    
    static func makeAddAction(context: Context, navigationController: NavigationController, type: Entity.Type) -> ActionClosure
    {
        ActionClosure { sender in
            let entity = type.init(context: context)
            print("Creating: \(entity)")
            // TODO: Create the detail controller
            // TODO: Push the detail controller
            // TODO: Refresh the table view list (insertion)
            context.quickSave()
        }
    }
}

class EntityListController: ViewController<
                                EntityListControllerModel,
                                EntityListViewModel,
                                EntityListView>
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let controllerModel = EntityListControllerModel(
            context: context,
            navigationController: navigationController,
            type: type)
        let viewModel = EntityListViewModel(
            context: context,
            navigationController: navigationController,
            type: type)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        navigationItem.rightBarButtonItem = Self.makeAddBarButtonItem(model: controllerModel)
    }
    
    // MARK: - Factory
    
    static func makeAddBarButtonItem(model: EntityListControllerModel) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: model.addButtonImage,
            style: model.addButtonStyle,
            target: model.addAction,
            action: #selector(model.addAction.perform(sender:)))
    }
}

class EntityListTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let didSelect = Self.makeDidSelect(
            context: context,
            navigationController: navigationController,
            type: type)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: NavigationController, type: Entity.Type) -> TableViewSelectionClosure
    {
        { selection in
            let all = type.all(context: context)
            let entity = all[selection.indexPath.row]
            print("Selected: \(entity)")
            // TODO: Get the detail controller
            // TODO: Push the detail controller
        }
    }
}

class EntityListTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, type: Entity.Type)
    {
        let cellModels = Self.makeCellModels(context: context, type: type)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(context: Context, type: Entity.Type) -> [[TableViewCellModel]]
    {
        [
            makeEntityListCellModels(context: context, type: type)
        ]
    }
    
    static func makeEntityListCellModels(context: Context, type: Entity.Type) -> [TableViewCellModel]
    {
        type
            .all(context: context)
            .compactMap { $0 as? Named }
            .map { TextCellModel(title: $0.title, disclosureIndicator: true) }
    }
}

class EntityListTableViewModel: TableViewModel
{
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let delegateModel = EntityListTableViewDelegateModel(
            context: context,
            navigationController: navigationController, type: type)
        let dataSourceModel = EntityListTableViewDataSourceModel(
            context: context,
            type: type)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegateModel: delegateModel,
            dataSourceModel: dataSourceModel,
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
