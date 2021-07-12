//
//  TableViewCellModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public enum ValueType
{
    case boolean
    case decimal
    case integer
    
    var title: String
    {
        switch self
        {
        case .boolean: return "Boolean".localized
        case .decimal: return "Decimal".localized
        case .integer: return "Integer".localized
        }
    }
}

public enum TransitionType
{
    case continuous
    case stateMachine
    
    var title: String
    {
        switch self
        {
        case .continuous: return "Continuous".localized
        case .stateMachine: return "State Machine".localized
        }
    }
}

public enum SelectionIdentifier
{
    case title
    case ideal
    case type
    case dimension
    case current
    case net
    
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
    
    case valueType(type: ValueType)
    case transitionType(type: TransitionType)
}

public protocol TableViewCellModel: AnyObject
{
    var selectionIdentifier: SelectionIdentifier { get set }
    
    static var cellClass: AnyClass { get }
    static var cellReuseIdentifier: String { get }
}

public extension TableViewCellModel
{
    static var cellReuseIdentifier: String
    {
        String(describing: cellClass)
    }
    
    func makeCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = type(of: self).cellReuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? TableViewCell<Self>
        {
            cell.configure(with: self)
        }
        
        return cell
    }
}
