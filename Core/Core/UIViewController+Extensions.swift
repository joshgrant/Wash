//
//  UIViewController+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit

extension UIViewController
{
    func embed(_ viewController: UIViewController)
    {
        addChild(viewController)
        view.embed(viewController.view)
        viewController.didMove(toParent: self)
    }
}
