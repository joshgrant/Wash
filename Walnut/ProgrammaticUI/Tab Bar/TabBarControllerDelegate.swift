//
//  TabBarControllerDelegate.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit

public typealias ShouldSelectTab = ((_ tabBarController: UITabBarController,
                              _ viewController: UIViewController) -> Bool)
public typealias DidSelectTab = ((_ tabBarController: UITabBarController,
                           _ viewController: UIViewController) -> Void)

open class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate
{
    public var shouldSelect: ShouldSelectTab?
    public var didSelect: DidSelectTab?
    
    public init(shouldSelect: ShouldSelectTab?, didSelect: DidSelectTab?)
    {
        self.shouldSelect = shouldSelect
        self.didSelect = didSelect
    }
    
    public func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool
    {
        return shouldSelect?(tabBarController, viewController) ?? false
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        didSelect?(tabBarController, viewController)
    }
}
