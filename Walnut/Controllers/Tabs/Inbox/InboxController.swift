//
//  InboxController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class InboxController: ViewController
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Inbox".localized }
    var tabBarImage: UIImage? { Icon.inbox.getImage() }
    var tabBarTag: Int { 2 }
    
    // MARK: - Initialization
    
    override init()
    {
        super.init()
        tabBarItem = makeTabBarItem()
        title = tabBarItemTitle
    }
}

extension InboxController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}
