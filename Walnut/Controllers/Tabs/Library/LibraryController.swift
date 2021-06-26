//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryController: ViewController
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }
    
    var tableView: TableView<LibraryTableViewModel>
    var tableViewModel: LibraryTableViewModel
    
    // MARK: - Initialization

    init(
        context: Context,
        navigationController: NavigationController)
    {
        let tableViewModel = LibraryTableViewModel(
            context: context,
            navigationController: navigationController)
        
        self.tableViewModel = tableViewModel
        self.tableView = TableView(model: tableViewModel)
        
        super.init()
        
        tabBarItem = makeTabBarItem()
        title = tabBarItemTitle
        
        view.embed(tableView)
    }
}

extension LibraryController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}
