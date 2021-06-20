//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit
import ProgrammaticUI

class LibraryController: ViewController<
                            LibraryControllerModel,
                            LibraryViewModel,
                            LibraryView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: LibraryControllerModel,
        viewModel: LibraryViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        title = model.tabBarItemTitle
    }
    
    convenience init(context: Context, navigationController: UINavigationController)
    {
        let controllerModel = LibraryControllerModel()
        let viewModel = LibraryViewModel(context: context, navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}

extension LibraryController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: model.tabBarItemTitle,
            image: model.tabBarImage,
            tag: model.tabBarTag)
    }
}

extension LibraryController: TableViewSelectionDelegate
{
    var presentingController: UIViewController
    {
        self
    }
}
