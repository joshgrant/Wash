//
//  EntityListControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListControllerModel: ControllerModel
{
    // MARK: - Variables
    
    private var type: Entity.Type
    
    var addAction: ActionClosure
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    var title: String { type.readableName.pluralize() }
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: NavigationController, type: Entity.Type, stateMachine: EntityListStateMachine)
    {
        self.type = type
        
        addAction = Self.makeAddAction(
            context: context,
            navigationController: navigationController,
            type: type,
            stateMachine: stateMachine)
    }
    
    // MARK: - Factory
    
    static func makeAddAction(
        context: Context,
        navigationController: NavigationController,
        type: Entity.Type,
        stateMachine: EntityListStateMachine) -> ActionClosure
    {
        // TODO: We should use a router instead
        // of having the controller creation happening here
        ActionClosure { sender in
            let entity = type.init(context: context)
            let detailController = entity.detailController(navigationController: navigationController, stateMachine: stateMachine)
            navigationController.pushViewController(detailController, animated: true)
            context.quickSave()
        }
    }
}
