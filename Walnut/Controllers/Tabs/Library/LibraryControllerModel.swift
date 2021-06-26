//
//  LibraryControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryControllerModel: ControllerModel
{
}

extension LibraryControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }
}
