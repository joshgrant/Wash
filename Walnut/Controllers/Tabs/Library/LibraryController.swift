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
    // MARK: - Variables
    
    var tableView: TableView<LibraryTableViewModel>
    
    // MARK: - Initialization
    
    required init(
        controllerModel: LibraryControllerModel,
        viewModel: LibraryViewModel)
    {
        tableView = TableView(model: controllerModel.tableViewModel)
        
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        title = model.tabBarItemTitle
        view.backgroundColor = model.backgroundColor
        view.embed(tableView)
    }
    
    convenience init(context: Context)
    {
        let controllerModel = LibraryControllerModel(context: context)
        let viewModel = LibraryViewModel()
        
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
