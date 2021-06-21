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
