//
//  RootController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit
//import ProgrammaticUI

class RootController: TabBarController
{
}

func makeTabBarViewControllers() -> [UIViewController]
{
    let dashboardController = DashboardController()
    let libraryController = LibraryController.makeController()
    let inboxController = InboxController.makeController()
    let settingsController = SettingsController.makeController()
    
    return [
        dashboardController,
        libraryController,
        inboxController,
        settingsController
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
