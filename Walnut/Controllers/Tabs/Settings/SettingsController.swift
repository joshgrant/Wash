//
//  SettingsController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

protocol SettingsControllerFactory: Factory, ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
}

// TODO: Maybe a container is a protocol (like a factory) that just specifies
// what fields are necessary. Then, we can have a builder that
// implements both the factory and the container protocols

class SettingsControllerContainer: Container
{
    public var tabBarItemTitle: String { "Settings".localized }
    public var tabBarImage: UIImage? { Icon.settings.getImage() }
    public var tabBarTag: Int { 3 }
}

extension SettingsControllerContainer: SettingsControllerFactory
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

class SettingsController: ViewController<SettingsControllerContainer>
{
    required init(container: SettingsControllerContainer)
    {
        super.init(container: container)
        
        tabBarItem = container.makeTabBarItem()
        title = container.tabBarItemTitle
    }
}
