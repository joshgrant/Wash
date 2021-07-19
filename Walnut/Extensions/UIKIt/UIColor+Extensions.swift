//
//  UIColor+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

extension UIColor
{
    public static let tableViewHeaderIcon = #colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.2941176471, alpha: 0.6)
    public static let tableViewHeaderFont = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2588235294, alpha: 0.6)
    
    public convenience init(hex: Int)
    {
        guard hex <= 0xffffffff else
        {
            fatalError("Pass a hexidecimal number")
        }
        
        let r = CGFloat((hex & 0xff000000) >> 24) / 255
        let g = CGFloat((hex & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hex & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hex & 0x000000ff) / 255
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
