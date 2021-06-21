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

class EntityListViewModel<E: Named>: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: EntityListTableViewModel<E>
    
    // MARK: - Initialization
    
    init(tableViewModel: EntityListTableViewModel<E>)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let tableViewModel = EntityListTableViewModel<E>(
            context: context,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class EntityListView<E: Named>: View<EntityListViewModel<E>>
{
    
}

class EntityListControllerModel<E: Named>: ControllerModel
{
    // MARK: - Variables
    
    var addAction: ActionClosure
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: NavigationController)
    {
        addAction = Self.makeAddAction(context: context, navigationController: navigationController)
    }
    
    // MARK: - Factory
    
    // TODO: Really, the context and the nav controller should be part of some "contextual" object that we pass along
    static func makeAddAction(context: Context, navigationController: NavigationController) -> ActionClosure
    {
        ActionClosure { sender in
            print("SELECTED ENTITY")
//            let entity = E(context: context)
//            // TODO: Entity detail controller
//            let detailController = SystemDetailController(system: system, navigationController: navigationController)
//            // TODO: Refresh the table view list
//            navigationController.pushViewController(detailController, animated: true)
//            context.quickSave()
        }
    }
}

class EntityListController<E: Named>: ViewController<
                                        EntityListControllerModel<E>,
                                        EntityListViewModel<E>,
                                        EntityListView<E>>
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let controllerModel = EntityListControllerModel<E>(context: context, navigationController: navigationController)
        let viewModel = EntityListViewModel<E>(context: context, navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        navigationItem.rightBarButtonItem = Self.makeAddBarButtonItem(model: controllerModel)
    }
    
    // MARK: - Factory
    
    static func makeAddBarButtonItem(model: EntityListControllerModel<E>) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: model.addButtonImage,
            style: model.addButtonStyle,
            target: model.addAction,
            action: #selector(model.addAction.perform(sender:)))
    }
}

// TABLE VIEW

class EntityListTableViewDelegateModel<E: Named>: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let didSelect = Self.makeDidSelect(
            context: context,
            navigationController: navigationController)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: NavigationController) -> TableViewSelectionClosure
    {
        { selection in
            //
            let all = E.all(context: context)
            let entity = all[selection.indexPath.row]
            print("Selected: \(entity)")
            // TODO: Get the detail controller
            // TODO: push the detail controller
        }
    }
}

class EntityListTableViewDataSourceModel<E: Named>: TableViewDataSourceModel
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
            makeEntityListCellModels(context: context)
        ]
    }
    
    static func makeEntityListCellModels(context: Context) -> [TableViewCellModel]
    {
        return E.all(context: context).compactMap { $0 as? Named }.map
        {
            TextCellModel(title: $0.title, disclosureIndicator: true)
        }
    }
}


class EntityListTableViewModel<E: Named>: TableViewModel<
                                                    EntityListTableViewDelegateModel<E>,
                                                    EntityListTableViewDataSourceModel<E>>
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let delegateModel = EntityListTableViewDelegateModel<E>(
            context: context,
            navigationController: navigationController)
        let dataSourceModel = EntityListTableViewDataSourceModel<E>(
            context: context)
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
