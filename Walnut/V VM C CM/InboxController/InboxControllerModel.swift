//
//  InboxControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class InboxControllerModel: ControllerModel
{
    var backgroundColor: UIColor
    {
        #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
}

extension InboxControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String
    {
        "Inbox".localized
    }
    
    var tabBarImage: UIImage?
    {
        Icon.inbox.getImage()
    }
    
    var tabBarTag: Int
    {
        2
    }
}
