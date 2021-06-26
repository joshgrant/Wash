//
//  SettingsController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class SettingsController: ViewController
{
    // MARK: - Variables
    
    public var tabBarItemTitle: String { "Settings".localized }
    public var tabBarImage: UIImage? { Icon.settings.getImage() }
    public var tabBarTag: Int { 3 }
    
    // MARK: - Initialization
    
    override init()
    {
        super.init()
        
        tabBarItem = makeTabBarItem()
        title = tabBarItemTitle
    }
}

extension SettingsController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}
