//
//  EntityListCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class EntityListCellMessage: Message
{
    // MARK: - Defined types
    
    enum Action
    {
        case selected
        case pinned
        case deleted
    }
    
    // MARK: - Variables
    
    weak var tableView: UITableView?
    var indexPath: IndexPath
    var action: Action
    var entityType: Entity.Type
    
    // MARK: - Initialization
    
    init(
        tableView: UITableView,
        indexPath: IndexPath,
        action: Action,
        entityType: Entity.Type)
    {
        self.tableView = tableView
        self.indexPath = indexPath
        self.action = action
        self.entityType = entityType
    }
}
