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
    // MARK: - Variables
    
    var tableView: TableView<DashboardTableViewModel>
    
    // MARK: - Initialization
    
    required init(
        controllerModel: DashboardControllerModel,
        viewModel: DashboardViewModel)
    {
        tableView = TableView(
            model: controllerModel.tableViewModel)
        
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        title = model.tabBarItemTitle
        view.backgroundColor = model.backgroundColor
        view.embed(tableView)
    }
    
    convenience init()
    {
        let controllerModel = DashboardControllerModel()
        let viewModel = DashboardViewModel()
        
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
