//
//  UINavigationController+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

public extension UINavigationController
{
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated: Bool,
                           completion: (() -> Void)?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
