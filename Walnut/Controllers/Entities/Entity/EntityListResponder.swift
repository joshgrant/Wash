//
//  EntityListPresenter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/24/21.
//

import Foundation
import UIKit
import ProgrammaticUI

protocol Responder: AnyObject {}

// The job of a responder is to take user-actions as
// initiated from the UI layer and decide what to do with them. These are "events" that are either generated from the UI or from notifications. Essentially a dispatcher.
class EntityListResponder: Responder
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    
    weak var router: EntityListRouter?
    weak var context: Context?
    weak var controller: UIViewController?
    
    init(
        router: EntityListRouter,
        entityType: Entity.Type,
        context: Context,
        controller: UIViewController)
    {
        self.entityType = entityType
        self.router = router
        self.context = context
        self.controller = controller
    }
    
    // MARK: - Functions
    
    @objc func userTouchedUpInsideAddButton(sender: UIButton)
    {
        guard let context = context else
        {
            assertionFailure("The context was nil")
            return
        }
        
        guard let controller = controller else
        {
            assertionFailure("The controller was nil")
            return
        }

        let entity = entityType.init(context: context)
        router?.transition(
            to: .detail(entity: entity),
            from: controller,
            completion: nil)
    }
    
    func userSelectedCell(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        // Find the entity
        // Route to the detail screen
    }
    
    func userSelectedPinCellTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        // Find the entity
        // Toggle the pn state of the entity
    }
    
    func userSelectedDeleteTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        // Find the entity
        // Delete the entity (make sure the data source is up to date)
        // Delete the cell from the table view
    }
}
