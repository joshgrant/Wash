//
//  RootDependencyContainer.swift
//  Walnut
//
//  Created by Joshua Grant on 7/19/21.
//

import Foundation
import UIKit

protocol RootFactory: Factory
{
    func makeTabBarController() -> UITabBarController
}

class RootDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var database: Database
    var stream: Stream
    
    var context: Context { database.context }
    
    // MARK: - Initialization
    
    init(database: Database? = nil, stream: Stream? = nil)
    {
        self.database = database ?? Database()
        self.stream = stream ?? Stream(identifier: .main)
    }
}

extension RootDependencyContainer: RootFactory
{
    // MARK: - Functions
    
    func makeTabBarController() -> UITabBarController
    {
        let controllers = makeNavigationControllers()
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.setViewControllers(controllers, animated: false)
        return tabBarController
    }
    
    // MARK: Utility
    
    private func makeNavigationControllers() -> [UINavigationController]
    {
        return [
            makeDashboardNavigationController(),
            makeLibraryNavigationController(),
            makeInboxNavigationController(),
            makeSettingsNavigationController()
        ]
    }
    
    private func makeDashboardNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let dashboardContainer = DashboardDependencyContainer(
            context: container.context,
            stream: container.stream)
        let dashboardController = DashboardController(container: dashboardContainer)
        navigationController.setViewControllers([dashboardController], animated: false)
        return navigationController
    }
    
    private func makeLibraryNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let libraryController = LibraryController(context: context, navigationController: navigationController)
        navigationController.setViewControllers([libraryController], animated: false)
        return navigationController
    }
    
    private func makeInboxNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let inboxController = InboxController()
        navigationController.setViewControllers([inboxController], animated: false)
        return navigationController
    }
    
    private func makeSettingsNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let settingsController = SettingsController()
        navigationController.setViewControllers([settingsController], animated: false)
        return navigationController
    }
    
}
