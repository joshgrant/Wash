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
