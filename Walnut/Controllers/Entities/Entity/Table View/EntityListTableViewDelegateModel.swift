//
//  EntityListTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation

class EntityListTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController, type: Entity.Type)
    {
        let didSelect = Self.makeDidSelect(
            context: context,
            navigationController: navigationController,
            type: type)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: NavigationController, type: Entity.Type) -> TableViewSelectionClosure
    {
        { selection in
            let all = type.all(context: context)
            let entity = all[selection.indexPath.row]
            print("Selected: \(entity)")
            let detailController = entity.detailController(navigationController: navigationController)
            navigationController.pushViewController(detailController, animated: true)
        }
    }
}
