//
//  LibraryTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import UIKit
import ProgrammaticUI

// TODO: Move into the SWIFTPM

public protocol TableViewSelectionDelegate: AnyObject
{
    var presentingController: UIViewController { get }
}

class LibraryTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: UINavigationController)
    {
        let didSelect = Self.makeDidSelect(context: context, navigationController: navigationController)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: UINavigationController) -> TableViewSelectionClosure
    {
        { selection in
            
            let entityType = EntityType.libraryVisible[selection.indexPath.row]
            
            // Now we need to get the list view controller for the entityType
            
            let listController = SystemListController(context: context)
            
            // The question is: how can we get the navigation controller
            // when initializing the delegate model?
            // It can't happen immediately - can we pass a reference instead?
            //
            
            navigationController.pushViewController(listController, animated: true)
            
            print("Selected: \(entityType)")
            
            selection.tableView.deselectRow(
                at: selection.indexPath,
                animated: true)
        }
    }
}
