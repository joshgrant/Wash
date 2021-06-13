//
//  LibraryControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var tableViewModel: LibraryTableViewModel
    var backgroundColor: UIColor { #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) }
    
    // MARK: - Initialization
    
    required init(tableViewModel: LibraryTableViewModel)
    {
        self.tableViewModel = tableViewModel
        super.init()
    }
    
    convenience init(context: Context)
    {
        let model = LibraryTableViewModel(context: context)
        self.init(tableViewModel: model)
    }
}

extension LibraryControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }
}
