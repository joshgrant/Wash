//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryController: ViewController<
                            LibraryControllerModel,
                            LibraryViewModel,
                            LibraryView>
{
    required init(
        controllerModel: LibraryControllerModel,
        viewModel: LibraryViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        view.backgroundColor = model.backgroundColor
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

extension LibraryController
{
    static func makeControllerModel() -> LibraryControllerModel
    {
        LibraryControllerModel()
    }
    
    static func makeViewModel() -> LibraryViewModel
    {
        LibraryViewModel()
    }
    
    static func makeController() -> LibraryController
    {
        let controllerModel = makeControllerModel()
        let viewModel = makeViewModel()
        
        return LibraryController(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}
