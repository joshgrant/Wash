//
//  UIStackView+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/21/21.
//

import UIKit

extension UIStackView
{
    func completelyRemove(view: UIView)
    {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func completelyRemoveAllArrangedSubviews()
    {
        for view in arrangedSubviews
        {
            completelyRemove(view: view)
        }
    }
}
