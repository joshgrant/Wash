//
//  SystemListTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/19/21.
//

import Foundation
import ProgrammaticUI

class SystemListTableViewDelegateModel: TableViewDelegateModel
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
            print("Did select system list at: \(selection.indexPath)")
            // TODO: Take the user to the system detail page
            let systems = System.allSystems(context: context)
            let system = systems[selection.indexPath.row]
            let detailController = SystemDetailController(system: system, navigationController: navigationController)
            navigationController.pushViewController(detailController, animated: true)
        }
    }
}
