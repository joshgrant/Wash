//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

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
    
//        case selectedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
//        case pinnedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
//        case deletedCell(tableView: UITableView, indexPath: IndexPath, model: TableViewCellModel)
//        
//        case changedText(textField: UITextField)
//        case finishedEditingText(textField: UITextField)
    
        case pinned(entity: Entity, location: ViewLocation)
        case deleted(entity: Entity, location: ViewLocation)
        case inserted(entity: Entity, location: ViewLocation)
        
        case selectedLink(entity: Entity, location: ViewLocation)
    
//        case duplicated(system: System)
    
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
    static let Flow = Identifier(value: "main.Flow")
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
    case ideal(type: SourceValueType)
    case current(type: SourceValueType)
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
    case inflow(flow: Flow)
    case outflow(flow: Flow)
    case flow(flow: Flow)
    
    case link(link: Named)
    
    case event(event: Event)
    
    case history(history: History)
    
    case note(note: Note)
    
//    case system(system: System)
    
    case valueType(type: SourceValueType) // Also used in NewStock
    case transitionType(type: TransitionType)
    
    // Current Ideal Boolean
    case currentBool(state: Bool)
    case idealBool(state: Bool)
}
