//
//  InboxController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

protocol InboxControllerFactory: Factory, ViewControllerTabBarDelegate
{
    
}

class InboxControllerContainer: Container
{
    var tabBarItemTitle: String { "Inbox".localized }
    var tabBarImage: UIImage? { Icon.inbox.getImage() }
    var tabBarTag: Int { 2 }
}

extension InboxControllerContainer: InboxControllerFactory
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

class InboxController: ViewController<InboxControllerContainer>
{
    // MARK: - Initialization
    
    required init(container: InboxControllerContainer)
    {
        super.init(container: container)
        
        tabBarItem = container.makeTabBarItem()
        title = container.tabBarItemTitle
    }
}
