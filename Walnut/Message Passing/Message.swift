//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import UIKit

enum HeaderType
{
    // General
    
    case info(ViewLocation)
    
    // Dashboard
    
    case pinned
    case suggested
    case forecast
    case priority
    
    // Entity Detail
    
    case stocks(ViewLocation)
    case flows(ViewLocation)
    case events(ViewLocation)
    case notes(ViewLocation)
    case history(ViewLocation)
    case conditions(ViewLocation)
    
    // New Stock
    
    case valueType
    case constraints
    
    // Stock Detail
    
    case states(ViewLocation) // New Stock, Stock Detail
    case inflows
    case outflows
    
    // Amount Detail
    
    case goal
    case chart
}

enum GoalType
{
    case boolean
    case percent
    case numeric
    case state
}

enum ViewType
{
    case new
    case list
    case detail
}

enum ViewLocation
{
    case dashboard
    case library
    case inbox
    case settings
    
    case editStates
    case constraints
    case goal(GoalType)
    
    case system(ViewType)
    case stock(ViewType)
    case flow(ViewType)
    case process(ViewType)
    case event(ViewType)
    case conversion(ViewType)
    case condition(ViewType)
    case symbol(ViewType)
    case note(ViewType)
    case unit(ViewType)
}

class Message: Unique, CustomStringConvertible
{
    enum Identifier
    {
        case createNew(type: EntityType)
    
        case selectedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
        case pinnedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
        case deletedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
        
        case changedText(textField: UITextField)
        case finishedEditingText(textField: UITextField)
    
        case pinned(entity: Entity, location: ViewLocation)
        case deleted(entity: Entity, location: ViewLocation)
        case inserted(entity: Entity, location: ViewLocation)
        
        case selectedLink(entity: Entity, location: ViewLocation)
    
        case duplicated(system: System)
    
        case headerAdd(header: HeaderType)
        case headerLink(header: HeaderType)
        case headerEdit(header: HeaderType)
        
        case navigationDone(location: ViewLocation)
        case navigationCancel(location: ViewLocation)
        case navigationNext(location: ViewLocation)
        
        case tappedInfoButton(location: ViewLocation)
    }
    
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







struct Identifier
{
    var value: String
    
    static let main = Identifier(
        value: "main")
    static let userInterface = Identifier(
        value: "main.userInterface")
    static let stockDetail = Identifier(
        value: "main.stockDetail")
    static let transferFlow = Identifier(value: "main.transferFlow")
}

extension Identifier: Equatable
{
    static func == (lhs: Identifier, rhs: Identifier) -> Bool
    {
        return lhs.value == rhs.value
    }
}



struct MessageToken
{
    var value: String
    
    static let windowVisible = MessageToken(value: "windowVisible")
    static let buttonPress = MessageToken(value: "buttonPress")
    
    struct EntityList
    {
        static let add = MessageToken(value: "entityList.addButton.touchUpInside")
        static let selectedCell = MessageToken(value: "entityList.cell.selected")
        static let pinned = MessageToken(value: "entityList.cell.pinned")
        static let deleted = MessageToken(value: "entityList.cell.deleted")
    }
}

extension MessageToken: Equatable
{
    static func == (lhs: MessageToken, rhs: MessageToken) -> Bool
    {
        lhs.value == rhs.value
    }
}


















public enum SelectionIdentifier
{
    case title
    case systemIdeal
    case ideal(type: ValueType)
    case current(type: ValueType)
    case infinity
    case type
    case dimension
    case net
    
    case newStockUnit
    case newStockName
    case stateMachine
    
    case newUnitName
    case newUnitSymbol
    
    case addState
    case stateTitle(state: NewStateModel)
    case stateFrom(state: NewStateModel)
    case stateTo(state: NewStateModel)
    case statePicker(state: NewStateModel)
    case currentState
    case idealState
    
    case minimum
    case maximum
    
    case baseUnit(isOn: Bool)
    case relativeTo
    
    case entity(entity: Entity)
    case entityType(type: EntityType)
    
    case pinned(entity: Pinnable)
    
    case fromStock(stock: Stock?)
    case toStock(stock: Stock?)
    case stock(stock: Stock)
    
    case flowAmount
    case flowDuration
    case requiresUserCompletion(state: Bool)
    case inflow(flow: TransferFlow)
    case outflow(flow: TransferFlow)
    case flow(flow: Flow)
    
    case link(link: Named)
    
    case event(event: Event)
    
    case history(history: History)
    
    case note(note: Note)
    
    case system(system: System)
    
    case valueType(type: ValueType) // Also used in NewStock
    case transitionType(type: TransitionType)
    
    // Current Ideal Boolean
    case currentBool(state: Bool)
    case idealBool(state: Bool)
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

class LinkSelectionMessage: Message
{
    var link: Entity
    var origin: LinkSearchController.Origin
    
    init(link: Entity, origin: LinkSearchController.Origin)
    {
        self.link = link
        self.origin = origin
    }
}
