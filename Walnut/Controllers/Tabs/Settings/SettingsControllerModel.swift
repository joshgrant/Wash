//
//  SettingsControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit
import ProgrammaticUI

public class SettingsControllerModel: ControllerModel
{
    var backgroundColor: UIColor
    {
        #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }
}

extension SettingsControllerModel: ControllerModelTabBarDelegate
{
    public var tabBarItemTitle: String
    {
        return "Settings".localized
    }
    
    public var tabBarImage: UIImage?
    {
        return Icon.settings.getImage()
    }
    
    public var tabBarTag: Int
    {
        return 3
    }
}
