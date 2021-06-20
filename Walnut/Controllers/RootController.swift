//
//  RootController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit
import ProgrammaticUI

class RootController: TabBarController
{
}

func makeTabBarViewControllers(context: Context) -> [UIViewController]
{
    let dashboardController = DashboardController(context: context)
    let dashboardNavigation = NavigationController(rootViewController: dashboardController)
    
    let libraryController = LibraryController(context: context)
    let libraryNavigation = NavigationController(rootViewController: libraryController)
    
    let inboxController = InboxController.makeController()
    let inboxNavigation = NavigationController(rootViewController: inboxController)
    
    let settingsController = SettingsController.makeController()
    let settingsNavigation = NavigationController(rootViewController: settingsController)
    
    return [
        dashboardNavigation,
        libraryNavigation,
        inboxNavigation,
        settingsNavigation
    ]
}

func makeTabBarControllerDelegate() -> TabBarControllerDelegate
{
    TabBarControllerDelegate(shouldSelect: { _, _ in
        return true
    }, didSelect: { _, viewController in
        print("Selected tab: \(viewController)")
    })
}

func makeTabBarController(viewControllers: [UIViewController]) -> TabBarController
{
    let delegate = makeTabBarControllerDelegate()
    let controller = RootController(delegate: delegate)
    
    controller.view.backgroundColor = .orange
    
    controller.viewControllers = viewControllers
    
    return controller
}
