//
//  ViewControllerTabBarDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

/// This is a protocol that should be implemented by a view controller
/// that wishise to be presented as the root of one of the tabs in a tab
/// bar controller

// TODO: Rename this to be more clear
public protocol ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
}

public protocol ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String { get }
    var tabBarImage: UIImage? { get }
    var tabBarTag: Int { get }
}
