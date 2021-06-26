//
//  DashboardController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit

class DashboardController: ViewController
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
    
    var tableView: TableView<DashboardTableViewModel>
    var tableViewModel: DashboardTableViewModel
    
    // MARK: - Initialization
    
    init(context: Context)
    {
        let tableViewModel = DashboardTableViewModel(context: context)
        
        self.tableView = TableView(model: tableViewModel)
        self.tableViewModel = tableViewModel
        
        super.init()
        
        title = tabBarItemTitle
        tabBarItem = makeTabBarItem()
        
        view.embed(tableView)
    }
}

extension DashboardController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}
