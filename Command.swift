//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 9/3/22.
//

import Foundation

var allCommands: [Command.Type] = [
    CommandHelp.self,
    CommandAdd.self
]

protocol CommandLineName
{
    var names: [String] { get }
}

class Command
{
}

class CommandHelp: Command
{
}

extension CommandHelp
{
    var names: [String] { ["help"] }
}

class CommandAdd: Command
{
    var entityType: EntityType
    var name: String?
    
    init(entityType: EntityType, name: String? = nil) {
        self.entityType = entityType
        self.name = name
    }
}

extension CommandAdd
{
    var names: [String] { ["add"] }
}

class CommandSetName: Command
{
    var entity: Entity
    var name: String
    
    init(entity: Entity, name: String) {
        self.entity = entity
        self.name = name
    }
}

extension CommandSetName
{
    var names: [String] { ["set-name"] }
}

class CommandHide: Command
{
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

extension CommandHide
{
    var names: [String] { ["hide"] }
}

class CommandUnhide: Command
{
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

extension CommandUnhide
{
    var names: [String] { ["unhide"] }
}

class CommandView: Command
{
    var entity: Printable
    
    init(entity: Printable) {
        self.entity = entity
    }
}

extension CommandView
{
    var names: [String] { ["view"] }
}

class CommandDelete: Command
{
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

extension CommandDelete
{
    var names: [String] { ["delete"] }
}

class CommandPin: Command
{
    var entity: Pinnable
    
    init(entity: Pinnable) {
        self.entity = entity
    }
}

extension CommandPin
{
    var names: [String] { ["pin"] }
}

class CommandUnpin: Command
{
    var entity: Pinnable
    
    init(entity: Pinnable) {
        self.entity = entity
    }
}

extension CommandUnpin
{
    var names: [String] { ["unpin"] }
}

class CommandHistory: Command
{
    var entity: Historable
    
    init(entity: Historable) {
        self.entity = entity
    }
}

extension CommandHistory
{
    var names: [String] { ["history"] }
}

class CommandSelect: Command
{
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
}

extension CommandSelect
{
    var names: [String] { ["select"] }
}

class CommandChoose: Command
{
    var index: Int
    var lastResult: [Entity]
    
    init(index: Int, lastResult: [Entity]) {
        self.index = index
        self.lastResult = lastResult
    }
}

extension CommandChoose
{
    var names: [String] { ["choose"] }
}

class CommandPinned: Command
{
}

extension CommandPinned
{
    var names: [String] { ["pinned"] }
}

class CommandLibrary: Command
{
}

extension CommandLibrary
{
    var names: [String] { ["library"] }
}

class CommandAll: Command
{
    var entityType: EntityType
    
    init(entityType: EntityType) {
        self.entityType = entityType
    }
}

extension CommandAll
{
    var names: [String] { ["all"] }
}

class CommandUnbalanced: Command
{
}

extension CommandUnbalanced
{
    var names: [String] { ["unbalanced"] }
}

class CommandPriority: Command
{
}

extension CommandPriority
{
    var names: [String] { ["priority"] }
}

class CommandEvents: Command
{
}

extension CommandEvents
{
    var names: [String] { ["events"] }
}

class CommandFlows: Command
{
}

extension CommandFlows
{
    var names: [String] { ["flows"] }
}

class CommandRunning: Command
{
}

extension CommandRunning
{
    var names: [String] { ["running"] }
}

class CommandHidden: Command
{
}

extension CommandHidden
{
    var names: [String] { ["hidden"] }
}

class CommandDashboard: Command
{
}

extension CommandDashboard
{
    var names: [String] { ["dashboard"] }
}

class CommandSuggest: Command
{
}

extension CommandSuggest
{
    var names: [String] { ["suggest"] }
}

class CommandNuke: Command
{
}

extension CommandNuke
{
    var names: [String] { ["nuke"] }
}

class CommandClear: Command
{
}

extension CommandClear
{
    var names: [String] { ["clear"] }
}

// MARK: - Stocks

class CommandSetStockType: Command
{
    var stock: Stock
    var type: SourceValueType
    
    init(stock: Stock, type: SourceValueType) {
        self.stock = stock
        self.type = type
    }
}

extension CommandSetStockType
{
    var names: [String] { ["set-stock-type"] }
}

class CommandSetCurrent: Command
{
    var stock: Stock
    var current: Double
    
    init(stock: Stock, current: Double) {
        self.stock = stock
        self.current = current
    }
}

extension CommandSetCurrent
{
    var names: [String] { ["set-current"] }
}

class CommandSetIdeal: Command
{
    var stock: Stock
    var ideal: Double
    
    init(stock: Stock, ideal: Double) {
        self.stock = stock
        self.ideal = ideal
    }
}

extension CommandSetIdeal
{
    var names: [String] { ["set-ideal"] }
}

class CommandSetMin: Command
{
    var stock: Stock
    var min: Double
    
    init(stock: Stock, min: Double) {
        self.stock = stock
        self.min = min
    }
}

extension CommandSetMin
{
    var names: [String] { ["set-min"] }
}

class CommandSetMax: Command
{
    var stock: Stock
    var max: Double
    
    init(stock: Stock, max: Double) {
        self.stock = stock
        self.max = max
    }
}

extension CommandSetMax
{
    var names: [String] { ["set-max"] }
}

class CommandSetUnit: Command
{
    var stock: Stock
    var unit: Unit
    
    init(stock: Stock, unit: Unit) {
        self.stock = stock
        self.unit = unit
    }
}

extension CommandSetUnit
{
    var names: [String] { ["set-unit"] }
}

class CommandLinkOutflow: Command
{
    var stock: Stock
    var flow: Flow
    
    init(stock: Stock, flow: Flow) {
        self.stock = stock
        self.flow = flow
    }
}

extension CommandLinkOutflow
{
    var names: [String] { ["link-outflow"] }
}

class CommandLinkInflow: Command
{
    var stock: Stock
    var flow: Flow
    
    init(stock: Stock, flow: Flow) {
        self.stock = stock
        self.flow = flow
    }
}

extension CommandLinkInflow
{
    var names: [String] { ["link-inflow"] }
}

class CommandUnlinkOutflow: Command
{
    var stock: Stock
    var flow: Flow
    
    init(stock: Stock, flow: Flow) {
        self.stock = stock
        self.flow = flow
    }
}

extension CommandUnlinkOutflow
{
    var names: [String] { ["unlink-outflow"] }
}

class CommandUnlinkInflow: Command
{
    var stock: Stock
    var flow: Flow
    
    init(stock: Stock, flow: Flow) {
        self.stock = stock
        self.flow = flow
    }
}

extension CommandUnlinkInflow
{
    var names: [String] { ["unlink-inflow"] }
}

class CommandLinkStockEvent: Command
{
    var stock: Stock
    var event: Event
    
    init(stock: Stock, event: Event) {
        self.stock = stock
        self.event = event
    }
}

extension CommandLinkStockEvent
{
    var names: [String] { ["link-stock-event"] }
}

class CommandUnlinkStockEvent: Command
{
    var stock: Stock
    var event: Event
    
    init(stock: Stock, event: Event) {
        self.stock = stock
        self.event = event
    }
}

extension CommandUnlinkStockEvent
{
    var names: [String] { ["unlink-stock-event"] }
}

// MARK: - Flows

class CommandSetAmount: Command
{
    var flow: Flow
    var amount: Double
    
    init(flow: Flow, amount: Double) {
        self.flow = flow
        self.amount = amount
    }
}

extension CommandSetAmount
{
    var names: [String] { ["set-amount"] }
}

class CommandSetDelay: Command
{
    var flow: Flow
    var delay: Double
    
    init(flow: Flow, delay: Double) {
        self.flow = flow
        self.delay = delay
    }
}

extension CommandSetDelay
{
    var names: [String] { ["set-delay"] }
}

class CommandSetDuration: Command
{
    var flow: Flow
    var duration: Double
    
    init(flow: Flow, duration: Double) {
        self.flow = flow
        self.duration = duration
    }
}

extension CommandSetDuration
{
    var names: [String] { ["set-duration"] }
}

class CommandSetRequires: Command
{
    var flow: Flow
    var requires: Bool
    
    init(flow: Flow, requires: Bool) {
        self.flow = flow
        self.requires = requires
    }
}

extension CommandSetRequires
{
    var names: [String] { ["set-requires"] }
}

class CommandSetFrom: Command
{
    var flow: Flow
    var stock: Stock
    
    init(flow: Flow, stock: Stock) {
        self.flow = flow
        self.stock = stock
    }
}

extension CommandSetFrom
{
    var names: [String] { ["set-from"] }
}

class CommandSetTo: Command
{
    var flow: Flow
    var stock: Stock
    
    init(flow: Flow, stock: Stock) {
        self.flow = flow
        self.stock = stock
    }
}

extension CommandSetTo
{
    var names: [String] { ["set-to"] }
}

class CommandRun: Command
{
    var flow: Flow
    
    init(flow: Flow) {
        self.flow = flow
    }
}

extension CommandRun
{
    var names: [String] { ["run"] }
}

class CommandLinkFlowEvent: Command
{
    var flow: Flow
    var event: Event
    
    init(flow: Flow, event: Event) {
        self.flow = flow
        self.event = event
    }
}

extension CommandLinkFlowEvent
{
    var names: [String] { ["link-flow-event"] }
}

class CommandUnlinkFlowEvent: Command
{
    var flow: Flow
    var event: Event
    
    init(flow: Flow, event: Event) {
        self.flow = flow
        self.event = event
    }
}

extension CommandUnlinkFlowEvent
{
    var names: [String] { ["unlink-flow-event"] }
}

class CommandFinish: Command
{
    var flow: Flow
    
    init(flow: Flow) {
        self.flow = flow
    }
}

extension CommandFinish
{
    var names: [String] { ["finish"] }
}

class CommandSetRepeats: Command
{
    var flow: Flow
    var repeats: Bool
    
    init(flow: Flow, repeats: Bool) {
        self.flow = flow
        self.repeats = repeats
    }
}

extension CommandSetRepeats
{
    var names: [String] { ["set-repeats"] }
}

// MARK: - Events

class CommandSetIsActive: Command
{
    var event: Event
    var isActive: Bool
    
    init(event: Event, isActive: Bool) {
        self.event = event
        self.isActive = isActive
    }
}

extension CommandSetIsActive
{
    var names: [String] { ["set-is-active"] }
}

class CommandLinkCondition: Command
{
    var event: Event
    var condition: Condition
    
    init(event: Event, condition: Condition) {
        self.event = event
        self.condition = condition
    }
}

extension CommandLinkCondition
{
    var names: [String] { ["link-condition"] }
}

class CommandSetConditionType: Command
{
    var event: Event
    var type: ConditionType
    
    init(event: Event, type: ConditionType) {
        self.event = event
        self.type = type
    }
}

extension CommandSetConditionType
{
    var names: [String] { ["set-condition-type"] }
}

class CommandLinkFlow: Command
{
    var event: Event
    var flow: Flow
    
    init(event: Event, flow: Flow) {
        self.event = event
        self.flow = flow
    }
}

extension CommandLinkFlow
{
    var names: [String] { ["link-flow"] }
}

class CommandSetCooldown: Command
{
    var event: Event
    var cooldown: Double
    
    init(event: Event, cooldown: Double) {
        self.event = event
        self.cooldown = cooldown
    }
}

extension CommandSetCooldown
{
    var names: [String] { ["set-cooldown"] }
}

// MARK: - Conditions

class CommandSetComparison: Command
{
    var condition: Condition
    var comparison: ComparisonType
    var type: String
    
    init(condition: Condition, comparison: ComparisonType, type: String) {
        self.condition = condition
        self.comparison = comparison
        self.type = type
    }
}

extension CommandSetComparison
{
    var names: [String] { ["set-comparison"] }
}

class CommandSetLeftHandSource: Command
{
    var condition: Condition
    var source: Source
    
    init(condition: Condition, source: Source) {
        self.condition = condition
        self.source = source
    }
}

extension CommandSetLeftHandSource
{
    var names: [String] { ["set-left-hand-source"] }
}

class CommandSetLeftHandStock: Command
{
    var condition: Condition
    var stock: Stock
    
    init(condition: Condition, stock: Stock) {
        self.condition = condition
        self.stock = stock
    }
}

extension CommandSetLeftHandStock
{
    var names: [String] { ["set-left-hand-stock"] }
}

class CommandSetLeftHandNumber: Command
{
    var condition: Condition
    var number: Double
    
    init(condition: Condition, number: Double) {
        self.condition = condition
        self.number = number
    }
}

extension CommandSetLeftHandNumber
{
    var names: [String] { ["set-left-hand-number"] }
}

class CommandSetRightHandSource: Command
{
    var condition: Condition
    var source: Source
    
    init(condition: Condition, source: Source) {
        self.condition = condition
        self.source = source
    }
}

extension CommandSetRightHandSource
{
    var names: [String] { ["set-right-hand-source"] }
}

class CommandSetRightHandStock: Command
{
    var condition: Condition
    var stock: Stock
    
    init(condition: Condition, stock: Stock) {
        self.condition = condition
        self.stock = stock
    }
}

extension CommandSetRightHandStock
{
    var names: [String] { ["set-right-hand-stock"] }
}

class CommandSetRightHandNumber: Command
{
    var condition: Condition
    var number: Double
    
    init(condition: Condition, number: Double) {
        self.condition = condition
        self.number = number
    }
}

extension CommandSetRightHandNumber
{
    var names: [String] { ["set-right-hand-number"] }
}

// MARK: - Systems

class CommandLinkSystemFlow: Command
{
    var system: System
    var flow: Flow
    
    init(system: System, flow: Flow) {
        self.system = system
        self.flow = flow
    }
}

extension CommandLinkSystemFlow
{
    var names: [String] { ["link-system-flow"] }
}

class CommandUnlinkSystemFlow: Command
{
    var system: System
    var flow: Flow
    
    init(system: System, flow: Flow) {
        self.system = system
        self.flow = flow
    }
}

extension CommandUnlinkSystemFlow
{
    var names: [String] { ["unlink-system-flow"] }
}

class CommandLinkSystemStock: Command
{
    var system: System
    var stock: Stock
    
    init(system: System, stock: Stock) {
        self.system = system
        self.stock = stock
    }
}

extension CommandLinkSystemStock
{
    var names: [String] { ["link-system-stock"] }
}

class CommandUnlinkSystemStock: Command
{
    var system: System
    var stock: Stock
    
    init(system: System, stock: Stock) {
        self.system = system
        self.stock = stock
    }
}

extension CommandUnlinkSystemStock
{
    var names: [String] { ["unlink-system-stock"] }
}

// MARK: - Processes

class CommandLinkProcessFlow: Command
{
    var process: Process
    var flow: Flow
    
    init(process: Process, flow: Flow) {
        self.process = process
        self.flow = flow
    }
}

extension CommandLinkProcessFlow
{
    var names: [String] { ["link-process-flow"] }
}

class CommandUnlinkProcessFlow: Command
{
    var process: Process
    var flow: Flow
    
    init(process: Process, flow: Flow) {
        self.process = process
        self.flow = flow
    }
}

extension CommandUnlinkProcessFlow
{
    var names: [String] { ["unlink-process-flow"] }
}

class CommandLinkProcessSubprocess: Command
{
    var process: Process
    var subprocess: Process
    
    init(process: Process, subprocess: Process) {
        self.process = process
        self.subprocess = subprocess
    }
}

extension CommandLinkProcessSubprocess
{
    var names: [String] { ["link-process-subprocess"] }
}

class CommandUnlinkProcessSubprocess: Command
{
    var process: Process
    var subprocess: Process
    
    init(process: Process, subprocess: Process) {
        self.process = process
        self.subprocess = subprocess
    }
}

extension CommandUnlinkProcessSubprocess
{
    var names: [String] { ["unlink-process-subprocess"] }
}

class CommandRunProcess: Command
{
    var process: Process
    
    init(process: Process) {
        self.process = process
    }
}

extension CommandRunProcess
{
    var names: [String] { ["run-process"] }
}

class CommandLinkProcessEvent: Command
{
    var process: Process
    var event: Event
    
    init(process: Process, event: Event) {
        self.process = process
        self.event = event
    }
}

extension CommandLinkProcessEvent
{
    var names: [String] { ["link-process-event"] }
}

class CommandUnlinkProcessEvent: Command
{
    var process: Process
    var event: Event
    
    init(process: Process, event: Event) {
        self.process = process
        self.event = event
    }
}

extension CommandUnlinkProcessEvent
{
    var names: [String] { ["unlink-process-event"] }
}

// MARK: - Other

class CommandBooleanStockFlow: Command
{
    var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension CommandBooleanStockFlow
{
    var names: [String] { ["boolean-stock-flow"] }
}
