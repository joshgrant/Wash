//
//  SystemListControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class SystemListControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var addAction: ActionClosure
    
    var addBarButtonImage: UIImage?
    {
        Icon.add.getImage()
    }
    
    var addButtonStyle: UIBarButtonItem.Style
    {
        .plain
    }
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: NavigationController)
    {
        addAction = Self.makeAddAction(context: context, navigationController: navigationController)
        super.init()
    }
    
    // MARK: - Factory
        
    static func makeAddAction(context: Context, navigationController: NavigationController) -> ActionClosure
    {
        ActionClosure { selector in
            let system = System(context: context)
            let detailController = SystemDetailController(system: system, navigationController: navigationController)
            // TODO: Refresh the table view list
            navigationController.pushViewController(detailController, animated: true)
            context.quickSave()
        }
    }
}
