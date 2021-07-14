//
//  SelectionIdentifier.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation

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
    case stateMachine
    
    case newUnitName
    case newUnitSymbol
    
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
