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
    
    init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        self.type = type
        
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
            let detailController = entity.detailController(navigationController: navigationController)
            navigationController.pushViewController(detailController, animated: true)
            // TODO: Refresh the table view list (insertion)
            context.quickSave()
        }
    }
}
