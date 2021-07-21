//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import UIKit

class Message: Unique, CustomStringConvertible
{
    var id = UUID()
    var timestamp: Date?
}

extension Message
{
    var description: String
    {
        "\(Self.self)"
    }
}

class TableViewSelectionMessage: Message
{
    var tableView: UITableView
    var cellModel: TableViewCellModel
    
    init(tableView: UITableView, cellModel: TableViewCellModel)
    {
        self.tableView = tableView
        self.cellModel = cellModel
    }
}

class TableViewEntitySelectionMessage: TableViewSelectionMessage
{
    var entity: Entity
    
    init(entity: Entity, tableView: UITableView, cellModel: TableViewCellModel)
    {
        self.entity = entity
        super.init(tableView: tableView, cellModel: cellModel)
    }
}

class SectionHeaderAddMessage: Message
{
    var entityToAddTo: Entity
    var entityType: Entity.Type
    
    init(entityToAddTo: Entity, entityType: Entity.Type)
    {
        self.entityToAddTo = entityToAddTo
        self.entityType = entityType
    }
}

class SectionHeaderSearchMessage: Message
{
    var entityToSearchFrom: Entity
    var typeToSearch: NamedEntity.Type
    
    init(entityToSearchFrom: Entity, typeToSearch: NamedEntity.Type)
    {
        self.entityToSearchFrom = entityToSearchFrom
        self.typeToSearch = typeToSearch
    }
}

class TextEditCellMessage: Message
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
    }
    
}

class ToggleCellMessage: Message
{
    // MARK: - Variables
    
    var state: Bool
    var selectionIdentifier: SelectionIdentifier
    
    // MARK: - Initialization
    
    init(state: Bool, selectionIdentifier: SelectionIdentifier)
    {
        self.state = state
        self.selectionIdentifier = selectionIdentifier
    }
}

enum EditType
{
    case dismiss
    case edit
    case beginEdit
}

class RightEditCellMessage: Message
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var content: String
    var editType: EditType
    
    // MARK: - Initialization
    
    init(selectionIdentifier: SelectionIdentifier, content: String, editType: EditType)
    {
        self.selectionIdentifier = selectionIdentifier
        self.content = content
        self.editType = editType
    }
}


class CancelCreationMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}

class SystemDetailTableViewSelectedMessage: Message
{
    // MARK: - Variables
    
    var tableView: UITableView
    var indexPath: IndexPath
    
    // MARK: - Initialization
    
    init(tableView: UITableView, indexPath: IndexPath)
    {
        self.tableView = tableView
        self.indexPath = indexPath
    }
}

class EntityPinnedMessage: Message
{
    // MARK: - Variables
    
    var isPinned: Bool
    var entity: Entity
    
    // MARK: - Initialization
    
    init(isPinned: Bool, entity: Entity)
    {
        self.isPinned = isPinned
        self.entity = entity
    }
}

class SystemDetailDuplicatedMessage: Message
{
    // MARK: - Variables
    
    var system: System
    
    // MARK: - Initialization
    
    init(system: System)
    {
        self.system = system
    }
}

class EntityInsertionMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}

class EntityListDeleteMessage: Message
{
    var entity: Entity
    var indexPath: IndexPath
    
    init(entity: Entity, indexPath: IndexPath)
    {
        self.entity = entity
        self.indexPath = indexPath
    }
}

class EntityListPinMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}


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


class EntityListAddButtonMessage: Message
{
    // MARK: - Variables
    
    weak var sender: AnyObject?
    var entityType: Entity.Type
    
    // MARK: - Initialization
    
    init(sender: AnyObject, entityType: Entity.Type)
    {
        self.sender = sender
        self.entityType = entityType
    }
}
