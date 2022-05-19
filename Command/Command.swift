//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 3/5/22.
//

import Foundation
import CoreData

enum Command
{
    case help
    
    case add(entityType: EntityType, name: String?)
    case setName(entity: Entity, name: String)
    case hide(entity: Entity)
    case unhide(entity: Entity)
    case view(entity: Printable)
    case delete(entity: Entity)
    case pin(entity: Pinnable)
    case unpin(entity: Pinnable)
    case history(entity: Historable)
    
    case select(index: Int)
    case choose(index: Int, lastResult: [Entity])
    
    case pinned
    case library
    case all(entityType: EntityType)
    case unbalanced
    case priority
    case events
    case flows
    case running
    case hidden
    
    case dashboard
    case suggest
    
    case nuke
    case clear
    
    // MARK: - Stocks
    
    case setStockType(stock: Stock, type: SourceValueType)
    case setCurrent(stock: Stock, current: Double)
    case setIdeal(stock: Stock, ideal: Double)
    case setMin(stock: Stock, min: Double)
    case setMax(stock: Stock, max: Double)
    case setUnit(stock: Stock, unit: Unit)
    case linkOutflow(stock: Stock, flow: Flow)
    case linkInflow(stock: Stock, flow: Flow)
    case unlinkOutflow(stock: Stock, flow: Flow)
    case unlinkInflow(stock: Stock, flow: Flow)
    case linkStockEvent(stock: Stock, event: Event)
    case unlinkStockEvent(stock: Stock, event: Event)
    
    // MARK: - Flows
    
    case setAmount(flow: Flow, amount: Double)
    case setDelay(flow: Flow, delay: Double)
    case setDuration(flow: Flow, duration: Double)
    case setRequires(flow: Flow, requires: Bool)
    case setFrom(flow: Flow, stock: Stock)
    case setTo(flow: Flow, stock: Stock)
    case run(flow: Flow)
    case linkFlowEvent(flow: Flow, event: Event)
    case unlinkFlowEvent(flow: Flow, event: Event)
    case finish(flow: Flow)
    case setRepeats(flow: Flow, repeats: Bool)
    
    // MARK: - Events
    
    case setIsActive(event: Event, isActive: Bool)
    case linkCondition(event: Event, condition: Condition)
    case setConditionType(event: Event, type: ConditionType)
    case linkFlow(event: Event, flow: Flow)
    case setCooldown(event: Event, cooldown: Double)
    
    // MARK: - Conditions
    
    case setComparison(condition: Condition,
                       comparison: ComparisonType,
                       type: String)
    case setLeftHandSource(condition: Condition, source: Source)
    case setLeftHandStock(condition: Condition, stock: Stock)
    case setLeftHandNumber(condition: Condition, number: Double)
    
    case setRightHandSource(condition: Condition, source: Source)
    case setRightHandStock(condition: Condition, stock: Stock)
    case setRightHandNumber(condition: Condition, number: Double)
    
    // MARK: - Systems
    
    case linkSystemFlow(system: System, flow: Flow)
    case unlinkSystemFlow(system: System, flow: Flow)
    case linkSystemStock(system: System, stock: Stock)
    case unlinkSystemStock(system: System, stock: Stock)
    
    // MARK: - Processes
    
    case linkProcessFlow(process: Process, flow: Flow)
    case unlinkProcessFlow(process: Process, flow: Flow)
    case linkProcessSubprocess(process: Process, subprocess: Process)
    case unlinkProcessSubprocess(process: Process, subprocess: Process)
    case runProcess(process: Process)
    case linkProcessEvent(process: Process, event: Event)
    case unlinkProcessEvent(process: Process, event: Event)
    
    // MARK: - Other
    
    case booleanStockFlow(name: String?)
}
