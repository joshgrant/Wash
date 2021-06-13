//
//  DashboardController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit
//import ProgrammaticUI

class DashboardController: ViewController<
                            DashboardControllerModel,
                            DashboardViewModel,
                            DashboardView>
{
    required init(
        controllerModel: DashboardControllerModel,
        viewModel: DashboardViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        view.backgroundColor = model.backgroundColor
    }
}

extension DashboardController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: model.tabBarItemTitle,
            image: model.tabBarImage,
            tag: model.tabBarTag)
    }
}

extension DashboardController
{
    static func makeDashboardControllerModel() -> DashboardControllerModel
    {
        DashboardControllerModel()
    }
    
    static func makeDashboardViewModel() -> DashboardViewModel
    {
        DashboardViewModel()
    }
    
    static func makeController() -> DashboardController
    {
        let controllerModel = makeDashboardControllerModel()
        let viewModel = makeDashboardViewModel()
        
        return DashboardController(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}
