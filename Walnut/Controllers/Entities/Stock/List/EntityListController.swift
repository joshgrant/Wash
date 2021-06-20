//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListViewModel<E: Entity & Listable & Named & Pinnable>: ViewModel
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

class EntityListView<E: Entity & Listable & Named & Pinnable>: View<EntityListViewModel<E>>
{
    
}

class EntityListControllerModel<E: Entity>: ControllerModel
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

class EntityListController<E: Entity & Listable & Pinnable & Named>: ViewController<
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
