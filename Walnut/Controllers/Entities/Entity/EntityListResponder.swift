//
//  EntityListPresenter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/24/21.
//

import Foundation
import UIKit

/// A responder handles UI-driven events or system generated notifications
protocol Responder: AnyObject {}

class EntityListResponder: Responder
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    
    // MARK: - Initialization
    
    init(entityType: Entity.Type)
    {
        self.entityType = entityType
    }
    
    // MARK: - Functions
    
    @objc func userTouchedUpInsideAddButton(sender: UIButton)
    {
        let message = EntityListAddButtonMessage(
            sender: sender,
            entityType: entityType)
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedCell(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = EntityListCellMessage(
            tableView: tableView,
            indexPath: indexPath,
            action: .selected,
            entityType: entityType)
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedPinCellTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = EntityListCellMessage(
            tableView: tableView,
            indexPath: indexPath,
            action: .pinned,
            entityType: entityType)
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedDeleteTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = EntityListCellMessage(
            tableView: tableView,
            indexPath: indexPath,
            action: .deleted,
            entityType: entityType)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
