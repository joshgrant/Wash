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
        let message = Message(
            token: MessageToken.EntityList.add,
            info: ["sender": sender,
                   "type": entityType])
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedCell(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = Message(
            token: MessageToken.EntityList.selectedCell,
            info: ["tableView": tableView,
                   "indexPath": indexPath,
                   "type": entityType])
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedPinCellTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = Message(
            token: MessageToken.EntityList.pinned,
            info: ["tableView": tableView,
                   "indexPath": indexPath,
                   "type": entityType])
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func userSelectedDeleteTrailingAction(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        let message = Message(
            token: MessageToken.EntityList.deleted,
            info: ["tableView": tableView,
                   "indexPath": indexPath,
                   "type": entityType])
        AppDelegate.shared.mainStream.send(message: message)
    }
}
