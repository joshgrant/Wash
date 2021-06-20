//
//  SystemListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import UIKit
import CoreData
import ProgrammaticUI

//class SystemListController: ViewController<
//                                SystemListControllerModel,
//                                SystemListViewModel,
//                                SystemListView>
//{
//    // MARK: - Initialization
//    
//    convenience init(context: Context, navigationController: NavigationController)
//    {
//        let controllerModel = SystemListControllerModel(context: context, navigationController: navigationController)
//        let viewModel = SystemListViewModel(context: context, navigationController: navigationController)
//        self.init(controllerModel: controllerModel, viewModel: viewModel)
//        
//        navigationItem.rightBarButtonItem = Self.makeAddBarButtonItem(model: controllerModel)
//    }
//    
//    // MARK: - Functions
//    
//    static func makeAddBarButtonItem(model: SystemListControllerModel) -> UIBarButtonItem
//    {
//        UIBarButtonItem(
//            image: model.addBarButtonImage,
//            style: model.addButtonStyle,
//            target: model.addAction,
//            action: #selector(model.addAction.perform(sender:)))
//    }
//}
