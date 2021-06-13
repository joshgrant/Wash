//
//  UIImage+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public extension UIImage
{
    convenience init?(icon: Icon)
    {
        self.init(systemName: icon.rawValue)
    }
}
