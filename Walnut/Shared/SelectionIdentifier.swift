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
    case ideal(type: AmountType)
    case current(type: AmountType)
    case infinity
    case type
    case dimension
    case net
    
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
    
    case valueType(type: ValueType)
    case transitionType(type: TransitionType)
}
