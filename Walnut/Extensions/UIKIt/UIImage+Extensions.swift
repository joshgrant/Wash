//
//  UIImage+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public extension UIImage {
    
    convenience init?(icon: Icon)
    {
        self.init(systemName: icon.rawValue)
    }
}
