//
//  SettingsController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class SettingsController: ViewController<
                            SettingsControllerModel,
                            SettingsViewModel,
                            SettingsView>
{
    required init(
        controllerModel: SettingsControllerModel,
        viewModel: SettingsViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        view.backgroundColor = model.backgroundColor
    }
}

extension SettingsController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: model.tabBarItemTitle,
            image: model.tabBarImage,
            tag: model.tabBarTag)
    }
}

extension SettingsController
{
    static func makeControllerModel() -> SettingsControllerModel
    {
        SettingsControllerModel()
    }
    
    static func makeViewModel() -> SettingsViewModel
    {
        SettingsViewModel()
    }
    
    static func makeController() -> SettingsController
    {
        let controllerModel = makeControllerModel()
        let viewModel = makeViewModel()
        
        return SettingsController(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}
