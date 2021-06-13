//
//  DashboardControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class DashboardControllerModel: ControllerModel
{
    var backgroundColor: UIColor
    {
        #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
}

extension DashboardControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String
    {
        "Dashboard".localized
    }
    
    var tabBarImage: UIImage?
    {
        Icon.dashboard.getImage()
    }
    
    var tabBarTag: Int
    {
        0
    }
}
