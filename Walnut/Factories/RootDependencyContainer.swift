//
//  RootContainer.swift
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

class RootContainer: Container
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

extension RootContainer: RootFactory
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
        let builder = DashboardListBuilder(context: context, stream: stream)
        let controller = DashboardListController(builder: builder)
        return UINavigationController(rootViewController: controller)
    }
    
    private func makeLibraryNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let container = LibraryControllerContainer(context: context, stream: stream)
        let controller = LibraryController(container: container)
        navigationController.setViewControllers([controller], animated: false)
        return navigationController
    }
    
    private func makeInboxNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let container = InboxControllerContainer()
        let inboxController = InboxController(container: container)
        navigationController.setViewControllers([inboxController], animated: false)
        return navigationController
    }
    
    private func makeSettingsNavigationController() -> UINavigationController
    {
        let navigationController = UINavigationController()
        let container = SettingsControllerContainer()
        let controller = SettingsController(container: container)
        navigationController.setViewControllers([controller], animated: false)
        return navigationController
    }
    
}
