//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 3/5/22.
//

import Foundation

enum Command
{
    case add(entityType: EntityType, name: String?)
    case setName(entity: Entity, name: String)
    case hide(entity: Entity)
    case unhide(entity: Entity)
    case view(entity: Printable)
    case delete(entity: Entity)
    case pin(entity: Pinnable)
    case unpin(entity: Pinnable)
    
    case select(index: Int)
    case choose(index: Int, lastResult: [Entity])
    
    case pinned
    case library
    case all(entityType: EntityType)
    
    case unbalanced
    case priority
    case events
    
    case save
    case quit
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
    
    // MARK: - Events
    
    case setIsActive(event: Event, isActive: Bool)
    case linkCondition(event: Event, condition: Condition)
    case setCondition(event: Event, condition: Condition)
    case setConditionType(event: Event, type: ConditionType)
    case linkFlow(event: Event, flow: Flow)
    case setCooldown(event: Event, cooldown: Double)
    
    // MARK: - Conditions
    
    case setComparison(condition: Condition,
                       comparison: ComparisonType,
                       type: String)
    case setLeftHand(condition: Condition, source: Source)
    case setRightHand(condition: Condition, source: Source)
    
    init?(command: CommandData, workspace: inout [Entity])
    {
        switch command.command
        {
        case "add":
            guard let type = command.getEntityType() else { break }
            let name = command.getName(startingAt: 1)
            self = .add(entityType: type, name: name)
        case "set-name":
            guard let entity = workspace.first as? SymbolNamed else { break }
            guard let name = command.getName() else { break }
            self = .setName(entity: entity, name: name)
        case "hide":
            guard let entity = workspace.first else { break }
            self = .hide(entity: entity)
        case "unhide":
            guard let entity = workspace.first else { break }
            self = .unhide(entity: entity)
        case "view":
            guard let entity = workspace.first as? Printable else { break }
            self = .view(entity: entity)
        case "delete":
            guard let entity = workspace.first else { break }
            self = .delete(entity: entity)
        case "pin":
            guard let entity = workspace.first as? Pinnable else { break }
            self = .pin(entity: entity)
        case "unpin":
            guard let entity = workspace.first as? Pinnable else { break }
            self = .unpin(entity: entity)
        case "select":
            guard let index = command.getIndex() else { break }
            self = .select(index: index)
        case "choose":
            self = .choose(index: <#T##Int#>, lastResult: <#T##[Entity]#>)
        case "pinned":
            self = .pinned
        case "library":
            self = .library
        case "all":
            self = .all(entityType: <#T##EntityType#>)
        case "unbalanced":
            self = .unbalanced
        case "priority":
            self = .priority
        case "events":
            self = .events
        case "save":
            self = .save
        case "quit":
            self = .quit
        case "nuke":
            self = .nuke
        case "clear":
            self = .clear
        case "set-stock-type":
            self = .setStockType(stock: <#T##Stock#>, type: <#T##SourceValueType#>)
        case "set-current":
            self = .setCurrent(stock: <#T##Stock#>, current: <#T##Double#>)
        case "set-ideal":
            self = .setIdeal(stock: <#T##Stock#>, ideal: <#T##Double#>)
        case "set-min":
            self = .setMin(stock: <#T##Stock#>, min: <#T##Double#>)
        case "set-max":
            self = .setMax(stock: <#T##Stock#>, max: <#T##Double#>)
        case "set-unit":
            self = .setUnit(stock: <#T##Stock#>, unit: <#T##Unit#>)
        case "link-outflow":
            self = .linkOutflow(stock: <#T##Stock#>, flow: <#T##Flow#>)
        case "link-inflow":
            self = .linkInflow(stock: <#T##Stock#>, flow: <#T##Flow#>)
        case "unlink-outflow":
            self = .unlinkOutflow(stock: <#T##Stock#>, flow: <#T##Flow#>)
        case "unlink-inflow":
            self = .unlinkInflow(stock: <#T##Stock#>, flow: <#T##Flow#>)
        case "link-stock-event":
            self = .linkStockEvent(stock: <#T##Stock#>, event: <#T##Event#>)
        case "unlink-stock-event":
            self = .unlinkStockEvent(stock: <#T##<<error type>>#>, event: <#T##Event#>)
        case "set-amount":
            self = .setAmount(flow: <#T##Flow#>, amount: <#T##Double#>)
        case "set-delay":
            self = .setDelay(flow: <#T##Flow#>, delay: <#T##Double#>)
        case "set-duration":
            self = .setDuration(flow: <#T##Flow#>, duration: <#T##Double#>)
        case "set-requires":
            self = .setRequires(flow: <#T##Flow#>, requires: <#T##Bool#>)
        case "set-from":
            self = .setFrom(flow: <#T##Flow#>, stock: <#T##Stock#>)
        case "set-to":
            self = .setTo(flow: <#T##Flow#>, stock: <#T##Stock#>)
        case "run":
            self = .run(flow: <#T##Flow#>)
        case "link-flow-event":
            self = .linkFlowEvent(flow: <#T##Flow#>, event: <#T##Event#>)
        case "unlink-flow-event":
            self = .unlinkFlowEvent(flow: <#T##Flow#>, event: <#T##Event#>)
        case "set-active":
            self = .setIsActive(event: <#T##Event#>, isActive: <#T##Bool#>)
        case "link-cndition":
            self = .linkCondition(event: <#T##Event#>, condition: <#T##Condition#>)
        case "set-condition":
            self = .setCondition(event: <#T##Event#>, condition: <#T##Condition#>)
        case "set-condition-type":
            self = .setConditionType(event: <#T##Event#>, type: <#T##ConditionType#>)
        case "link-flow":
            self = .linkFlow(event: <#T##Event#>, flow: <#T##Flow#>)
        case "set-cooldown":
            self = .setCooldown(event: <#T##Event#>, cooldown: <#T##Double#>)
        case "set-comparison":
            self = .setComparison(condition: <#T##Condition#>, comparison: <#T##ComparisonType#>, type: <#T##String#>)
        case "set-left-hand":
            self = .setLeftHand(condition: <#T##Condition#>, source: <#T##Source#>)
        case "set-right-hand":
            self = .setRightHand(condition: <#T##Condition#>, source: <#T##Source#>)
        default:
            return nil
        }
        
        print("Failed to run \(command.command) with \(command.arguments)")
        return nil
    }
    
    func run(context: Context, workspace: inout [Entity])
    {
        switch self
        {
        case .add(entityType: let entityType, name: let name):
            entityType.insertNewEntity(into: context, name: name)
        case .setName(entity: let entity, name: let name):
            break
        case .hide(entity: let entity):
            break
        case .unhide(entity: let entity):
            break
        case .view(entity: let entity):
            break
        case .delete(entity: let entity):
            break
        case .pin(entity: let entity):
            break
        case .unpin(entity: let entity):
            break
        case .select(index: let index):
            break
        case .choose(index: let index, lastResult: let lastResult):
            break
        case .pinned:
            break
        case .library:
            break
        case .all(entityType: let entityType):
            break
        case .unbalanced:
            break
        case .priority:
            break
        case .events:
            break
        case .save:
            break
        case .quit:
            break
        case .nuke:
            break
        case .clear:
            break
        case .setStockType(stock: let stock, type: let type):
            break
        case .setCurrent(stock: let stock, current: let current):
            break
        case .setIdeal(stock: let stock, ideal: let ideal):
            break
        case .setMin(stock: let stock, min: let min):
            break
        case .setMax(stock: let stock, max: let max):
            break
        case .setUnit(stock: let stock, unit: let unit):
            break
        case .linkOutflow(stock: let stock, flow: let flow):
            break
        case .linkInflow(stock: let stock, flow: let flow):
            break
        case .unlinkOutflow(stock: let stock, flow: let flow):
            break
        case .unlinkInflow(stock: let stock, flow: let flow):
            break
        case .linkStockEvent(stock: let stock, event: let event):
            break
        case .unlinkEvent:
            break
        case .setAmount(flow: let flow, amount: let amount):
            break
        case .setDelay(flow: let flow, delay: let delay):
            break
        case .setDuration(flow: let flow, duration: let duration):
            break
        case .setRequires:
            break
        case .setFrom:
            break
        case .setTo(flow: let flow, stock: let stock):
            break
        case .run(flow: let flow):
            break
        case .linkFlowEvent(flow: let flow, event: let event):
            break
        case .setIsActive(event: let event, isActive: let isActive):
            break
        case .linkCondition(event: let event, condition: let condition):
            break
        case .setCondition(event: let event, condition: let condition):
            break
        case .setConditionType(event: let event, type: let type):
            break
        case .linkFlow(event: let event, flow: let flow):
            break
        case .setCooldown(event: let event, cooldown: let cooldown):
            break
        case .setComparison(condition: let condition, comparison: let comparison, type: let type):
            break
        case .setLeftHand(condition: let condition, source: let source):
            break
        case .setRightHand(condition: let condition, source: let source):
            break
        }
    }
}

struct CommandData
{
    var command: String
    var arguments: [String]
    
    init(input: String)
    {
        var command = ""
        var arguments: [String] = []
        
        var word = ""
        var openQuote = false
        
        func assign()
        {
            if command == ""
            {
                command = word
            }
            else
            {
                arguments.append(word)
            }
            
            word = ""
        }
        
        for char in Array(input)
        {
            if char == "\""
            {
                openQuote.toggle()
            }
            
            if !openQuote && char == " "
            {
                assign()
            }
            else
            {
                word.append(char)
            }
        }
        
        assign()
        
        self.command = command
        self.arguments = arguments
    }
    
    func getEntityType() -> EntityType?
    {
        guard arguments.count > 0 else
        {
            print("No arguments.")
            return nil
        }
        
        return EntityType(string: arguments[0])
    }
    
    func getName(startingAt index: Int = 0) -> String?
    {
        guard arguments.count > index else
        {
            print("No arguments.")
            return nil
        }
        
        return arguments[index...].joined(separator: " ")
    }
    
    func getIndex() -> Int?
    {
        guard let first = arguments.first else
        {
            print("No arguments.")
            return nil
        }
        
        guard let number = Int(first) else
        {
            print("First argument was not an integer.")
            return nil
        }
        
        return number
    }
    
    func getEntity(in workspace: [Entity], at index: Int) -> Entity?
    {
        guard index < workspace.count else
        {
            print("index was out of bounds")
            return nil
        }
        
        return workspace[index]
    }
}
