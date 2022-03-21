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
    
    init?(commandData: CommandData, workspace: inout [Entity], lastResult: [Entity])
    {
        switch commandData.command
        {
        case "add":
            guard let type = commandData.getEntityType() else { break }
            let name = commandData.getName(startingAt: 1)
            self = .add(entityType: type, name: name)
        case "set-name":
            guard let entity = workspace.first as? SymbolNamed else { break }
            guard let name = commandData.getName() else { break }
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
            guard let index = commandData.getIndex() else { break }
            self = .select(index: index)
        case "choose":
            guard let index = commandData.getIndex() else { break }
            self = .choose(index: index, lastResult: lastResult)
        case "pinned":
            self = .pinned
        case "library":
            self = .library
        case "all":
            guard let entityType = commandData.getEntityType() else { break }
            self = .all(entityType: entityType)
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
            guard let stock = workspace.first as? Stock else { break }
            guard let type = commandData.getSourceValueType() else { break }
            self = .setStockType(stock: stock, type: type)
        case "set-current":
            guard let stock = workspace.first as? Stock else { break }
            guard let number = commandData.getNumber() else { break }
            self = .setCurrent(stock: stock, current: number)
        case "set-ideal":
            guard let stock = workspace.first as? Stock else { break }
            guard let number = commandData.getNumber() else { break }
            self = .setIdeal(stock: stock, ideal: number)
        case "set-min":
            guard let stock = workspace.first as? Stock else { break }
            guard let number = commandData.getNumber() else { break }
            self = .setMin(stock: stock, min: number)
        case "set-max":
            guard let stock = workspace.first as? Stock else { break }
            guard let number = commandData.getNumber() else { break }
            self = .setMax(stock: stock, max: number)
        case "set-unit":
            guard let (stock, unit): (Stock, Unit) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .setUnit(stock: stock, unit: unit)
        case "link-outflow":
            guard let (stock, flow): (Stock, Flow) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .linkOutflow(stock: stock, flow: flow)
        case "link-inflow":
            guard let (stock, flow): (Stock, Flow) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .linkInflow(stock: stock, flow: flow)
        case "unlink-outflow":
            guard let (stock, flow): (Stock, Flow) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .unlinkOutflow(stock: stock, flow: flow)
        case "unlink-inflow":
            guard let (stock, flow): (Stock, Flow) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .unlinkInflow(stock: stock, flow: flow)
        case "link-stock-event":
            guard let (stock, event): (Stock, Event) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .linkStockEvent(stock: stock, event: event)
        case "unlink-stock-event":
            guard let (stock, event): (Stock, Event) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .unlinkStockEvent(stock: stock, event: event)
        case "set-amount":
            guard let (flow, amount): (Flow, Double) = getEntityAndDouble(commandData: commandData, workspace: workspace) else { break }
            self = .setAmount(flow: flow, amount: amount)
        case "set-delay":
            guard let (flow, delay): (Flow, Double) = getEntityAndDouble(commandData: commandData, workspace: workspace) else { break }
            self = .setDelay(flow: flow, delay: delay)
        case "set-duration":
            guard let (flow, duration): (Flow, Double) = getEntityAndDouble(commandData: commandData, workspace: workspace) else { break }
            self = .setDuration(flow: flow, duration: duration)
        case "set-requires":
            guard let (flow, requires): (Flow, Bool) = getEntityAndBool(commandData: commandData, workspace: workspace) else { break }
            self = .setRequires(flow: flow, requires: requires)
        case "set-from":
            guard let (flow, stock): (Flow, Stock) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .setFrom(flow: flow, stock: stock)
        case "set-to":
            guard let (flow, stock): (Flow, Stock) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .setTo(flow: flow, stock: stock)
        case "run":
            guard let flow: Flow = getEntity(in: workspace) else { break }
            self = .run(flow: flow)
        case "link-flow-event":
            guard let (flow, event): (Flow, Event) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .linkFlowEvent(flow: flow, event: event)
        case "unlink-flow-event":
            guard let (flow, event): (Flow, Event) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .unlinkFlowEvent(flow: flow, event: event)
        case "set-active":
            guard let (event, isActive): (Event, Bool) = getEntityAndBool(commandData: commandData, workspace: workspace) else { break }
            self = .setIsActive(event: event, isActive: isActive)
        case "link-cndition":
            self = .linkCondition(event: <#T##Event#>, condition: <#T##Condition#>)
        case "set-condition":
            self = .setCondition(event: <#T##Event#>, condition: <#T##Condition#>)
        case "set-condition-type":
            self = .setConditionType(event: <#T##Event#>, type: <#T##ConditionType#>)
        case "link-flow":
            guard let (event, flow): (Event, Flow) = getEntities(commandData: commandData, workspace: workspace) else { break }
            self = .linkFlow(event: event, flow: flow)
        case "set-cooldown":
            guard let (event, cooldown): (Event, Double) = getEntityAndDouble(commandData: commandData, workspace: workspace) else { break }
            self = .setCooldown(event: event, cooldown: cooldown)
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
        case .unlinkStockEvent(stock: let stock, event: let event):
            break
        case .setAmount(flow: let flow, amount: let amount):
            break
        case .setDelay(flow: let flow, delay: let delay):
            break
        case .setDuration(flow: let flow, duration: let duration):
            break
        case .setRequires(flow: let flow, requires: let requires):
            break
        case .setFrom(flow: let flow, stock: let stock):
            break
        case .setTo(flow: let flow, stock: let stock):
            break
        case .run(flow: let flow):
            break
        case .linkFlowEvent(flow: let flow, event: let event):
            break
        case .unlinkFlowEvent(flow: let flow, event: let event):
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
    
    func getEntity<T: Entity>(in workspace: [Entity], at index: Int = 0) -> T?
    {
        guard workspace.count > index else
        {
            print("The index \(index) is out of bounds.")
            return nil
        }
        
        guard let entity = workspace[index] as? T else
        {
            print("The entity at index \(index) was not a(n) \(T.self)")
            return nil
        }
        
        return entity
    }
    
    func getEntities<A: Entity, B: Entity>(commandData: CommandData, workspace: [Entity]) -> (A, B)?
    {
        guard let index = commandData.getIndex() else
        {
            print("No index.")
            return nil
        }
        
        let first: A? = getEntity(in: workspace, at: 0)
        let second: B? = getEntity(in: workspace, at: index)
        
        guard let f = first, let s = second else
        {
            return nil
        }
        
        return (f, s)
    }
    
    func getEntityAndDouble<T: Entity>(commandData: CommandData, workspace: [Entity]) -> (T, Double)?
    {
        guard let argument = commandData.arguments.first, let number = Double(argument) else
        {
            print("Please enter a number.")
            return nil
        }
        
        guard let entity = workspace.first as? T else
        {
            print("No entity, or entity isn't a \(T.self)")
            return nil
        }
        
        return (entity, number)
    }

    func getEntityAndBool<T: Entity>(commandData: CommandData, workspace: [Entity]) -> (T, Bool)?
    {
        guard let argument = commandData.arguments.first, let bool = Bool(argument) else
        {
            print("Please enter a boolean")
            return nil
        }
        
        guard let entity = workspace.first as? T else
        {
            print("No entity, or entity isn't a \(T.self)")
            return nil
        }
        
        return (entity, bool)
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
            print("Index was out of bounds.")
            return nil
        }
        
        return workspace[index]
    }
    
    func getSourceValueType() -> SourceValueType?
    {
        guard let first = arguments.first?.lowercased() else
        {
            print("No arguments.")
            return nil
        }
        
        return SourceValueType(string: first)
    }
    
    func getNumber() -> Double?
    {
        guard let first = arguments.first else
        {
            print("No arguments.")
            return nil
        }
        
        guard let number = Double(first) else
        {
            print("First argument wasn't a number.")
            return nil
        }
        
        return number
    }
}
