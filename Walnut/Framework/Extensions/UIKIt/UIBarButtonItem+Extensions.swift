//
//  UIBarButtonItem+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

extension UIBarButtonItem
{
    @available(iOS 14.0, *)
    convenience init(systemItem: UIBarButtonItem.SystemItem, actionClosure: ActionClosure)
    {
        self.init(systemItem: systemItem)
        self.target = actionClosure
        self.action = #selector(actionClosure.perform(sender:))
    }
}
