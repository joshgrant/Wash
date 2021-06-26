//
//  LibraryTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import UIKit

class LibraryTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let didSelect = Self.makeDidSelect(context: context, navigationController: navigationController)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: NavigationController) -> TableViewSelectionClosure
    {
        { selection in
            
            let entityType = EntityType.libraryVisible[selection.indexPath.row]
            let managedType = entityType.managedObjectType
            let listController = EntityListController(
                type: managedType,
                context: context,
                navigationController: navigationController)
            navigationController.pushViewController(listController, animated: true)
        }
    }
}
