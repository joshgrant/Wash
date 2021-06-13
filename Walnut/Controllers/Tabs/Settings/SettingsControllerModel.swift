//
//  SettingsControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class SettingsControllerModel: ControllerModel
{
    var backgroundColor: UIColor
    {
        #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }
}

extension SettingsControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String
    {
        return "Settings".localized
    }
    
    var tabBarImage: UIImage?
    {
        return Icon.settings.getImage()
    }
    
    var tabBarTag: Int
    {
        return 3
    }
}
