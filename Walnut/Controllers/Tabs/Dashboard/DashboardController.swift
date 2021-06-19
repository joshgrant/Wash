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
    // MARK: - Initialization
    
    required init(
        controllerModel: DashboardControllerModel,
        viewModel: DashboardViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        title = model.tabBarItemTitle
    }
    
    convenience init(context: Context)
    {
        let controllerModel = DashboardControllerModel()
        let viewModel = DashboardViewModel(context: context)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
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
