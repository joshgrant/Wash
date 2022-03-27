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
    case flows
    case running
    
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
    
    init?(commandData: CommandData, workspace: inout [Entity], lastResult: [Entity], quit: inout Bool)
    {
        switch commandData.command.lowercased()
        {
        case "add":
            guard let type = commandData.getEntityType() else { return nil }
            let name = commandData.getName(startingAt: 1)
            self = .add(entityType: type, name: name)
        case "set-name":
            guard let entity = workspace.first as? SymbolNamed else { return nil }
            guard let name = commandData.getName() else { return nil }
            self = .setName(entity: entity, name: name)
        case "hide":
            guard let entity = workspace.first else { return nil }
            self = .hide(entity: entity)
        case "unhide":
            guard let entity = workspace.first else { return nil }
            self = .unhide(entity: entity)
        case "view":
            guard let entity = workspace.first as? Printable else { return nil }
            self = .view(entity: entity)
        case "delete":
            guard let entity = workspace.first else { return nil }
            self = .delete(entity: entity)
        case "pin":
            guard let entity = workspace.first as? Pinnable else { return nil }
            self = .pin(entity: entity)
        case "unpin":
            guard let entity = workspace.first as? Pinnable else { return nil }
            self = .unpin(entity: entity)
        case "select":
            guard let index = commandData.getIndex() else { return nil }
            self = .select(index: index)
        case "choose":
            guard let index = commandData.getIndex() else { return nil }
            guard index < lastResult.count else { return nil }
            self = .choose(index: index, lastResult: lastResult)
        case "pinned":
            self = .pinned
        case "library":
            self = .library
        case "all":
            guard let entityType = commandData.getEntityType() else { return nil }
            self = .all(entityType: entityType)
        case "unbalanced":
            self = .unbalanced
        case "priority":
            self = .priority
        case "events":
            self = .events
        case "flows":
            self = .flows
        case "running":
            self = .running
        case "quit":
            quit = true
            return nil
        case "nuke":
            self = .nuke
        case "clear":
            self = .clear
        case "set-stock-type":
            guard let stock = workspace.first as? Stock else { return nil }
            guard let type = commandData.getSourceValueType() else { return nil }
            self = .setStockType(stock: stock, type: type)
        case "set-current":
            guard let stock = workspace.first as? Stock else { return nil }
            guard let number = commandData.getNumber() else { return nil }
            self = .setCurrent(stock: stock, current: number)
        case "set-ideal":
            guard let stock = workspace.first as? Stock else { return nil }
            guard let number = commandData.getNumber() else { return nil }
            self = .setIdeal(stock: stock, ideal: number)
        case "set-min":
            guard let stock = workspace.first as? Stock else { return nil }
            guard let number = commandData.getNumber() else { return nil }
            self = .setMin(stock: stock, min: number)
        case "set-max":
            guard let stock = workspace.first as? Stock else { return nil }
            guard let number = commandData.getNumber() else { return nil }
            self = .setMax(stock: stock, max: number)
        case "set-unit":
            guard let (stock, unit): (Stock, Unit) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .setUnit(stock: stock, unit: unit)
        case "link-outflow":
            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .linkOutflow(stock: stock, flow: flow)
        case "link-inflow":
            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .linkInflow(stock: stock, flow: flow)
        case "unlink-outflow":
            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .unlinkOutflow(stock: stock, flow: flow)
        case "unlink-inflow":
            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .unlinkInflow(stock: stock, flow: flow)
        case "set-amount":
            guard let (flow, amount): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
            guard amount > 0 else
            {
                print("Flow amount can't be < 0. Try switching the inflow/outflow arrangement.")
                return nil
            }
            self = .setAmount(flow: flow, amount: amount)
        case "set-delay":
            guard let (flow, delay): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
            self = .setDelay(flow: flow, delay: delay)
        case "set-duration":
            guard let (flow, duration): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
            self = .setDuration(flow: flow, duration: duration)
        case "set-requires":
            guard let (flow, requires): (Flow, Bool) = Self.getEntityAndBool(commandData: commandData, workspace: workspace) else { return nil }
            self = .setRequires(flow: flow, requires: requires)
        case "set-from":
            guard let (flow, stock): (Flow, Stock) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .setFrom(flow: flow, stock: stock)
        case "set-to":
            guard let (flow, stock): (Flow, Stock) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .setTo(flow: flow, stock: stock)
        case "run":
            guard let flow: Flow = Self.getEntity(in: workspace) else { return nil }
            self = .run(flow: flow)
        case "finish":
            guard let flow: Flow = Self.getEntity(in: workspace) else { return nil }
            self = .finish(flow: flow)
        case "set-active":
            guard let (event, isActive): (Event, Bool) = Self.getEntityAndBool(commandData: commandData, workspace: workspace) else { return nil }
            self = .setIsActive(event: event, isActive: isActive)
        case "link-condition":
            guard let (event, condition): (Event, Condition) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
            self = .linkCondition(event: event, condition: condition)
        case "set-condition-type":
            guard let event = Self.getEntity(in: workspace) as? Event else { return nil }
            guard let conditionType = commandData.getConditionType() else { return nil }
            self = .setConditionType(event: event, type: conditionType)
        case "set-cooldown":
            guard let (event, cooldown): (Event, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
            self = .setCooldown(event: event, cooldown: cooldown)
        case "set-comparison":
            guard let condition = Self.getEntity(in: workspace) as? Condition else { return nil }
            guard let comparison = commandData.getComparisonType() else { return nil }
            guard let type = commandData.getArgument(at: 1) else { return nil }
            self = .setComparison(condition: condition, comparison: comparison, type: type)
        case "set-left-hand":
            if let (condition, number): (Condition, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setLeftHandNumber(condition: condition, number: number)
            }
            else if let (condition, source): (Condition, Source) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setLeftHandSource(condition: condition, source: source)
            }
            else if let (condition, stock): (Condition, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setLeftHandStock(condition: condition, stock: stock)
            }
            else
            {
                print("Failed to parse the left-hand.")
                return nil
            }
        case "set-right-hand":
            if let (condition, number): (Condition, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setRightHandNumber(condition: condition, number: number)
            }
            else if let (condition, source): (Condition, Source) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setRightHandSource(condition: condition, source: source)
            }
            else if let (condition, stock): (Condition, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .setRightHandStock(condition: condition, stock: stock)
            }
            else
            {
                print("Failed to parse the right-hand.")
                return nil
            }
        case "link-flow":
            if let (event, flow): (Event, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .linkFlow(event: event, flow: flow)
            }
            else if let (system, flow): (System, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .linkSystemFlow(system: system, flow: flow)
            }
            else
            {
                print("Failed to link flow. No matching types.")
                return nil
            }
        case "unlink-flow":
            if let (system, flow): (System, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .unlinkSystemFlow(system: system, flow: flow)
            }
            else
            {
                print("Failed to unlink flow. No matching types.")
                return nil
            }
        case "link-stock":
            if let (system, stock): (System, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .linkSystemStock(system: system, stock: stock)
            }
            else
            {
                print("Failed to link stock. No matching types")
                return nil
            }
        case "unlink-stock":
            if let (system, stock): (System, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .unlinkSystemStock(system: system, stock: stock)
            }
            else
            {
                print("Failed to unlink stock. No matching types")
                return nil
            }
        case "link-event":
            if let (flow, event): (Flow, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .linkFlowEvent(flow: flow, event: event)
            }
            else if let (stock, event): (Stock, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
            {
                self = .linkStockEvent(stock: stock, event: event)
            }
            else
            {
                print("Failed to link event. No matching types.")
                return nil
            }
        case "unlink-event":
            if let (flow, event): (Flow, Event) = Self.getEntities(commandData: commandData, workspace: workspace)
            {
                self = .unlinkFlowEvent(flow: flow, event: event)
            }
            else if let (stock, event): (Stock, Event) = Self.getEntities(commandData: commandData, workspace: workspace)
            {
                self = .unlinkStockEvent(stock: stock, event: event)
            }
            else
            {
                print("Failed to unlink event. No matching types.")
                return nil
            }
        default:
            return nil
        }
    }
    
    func run(database: Database) -> [Entity]?
    {
        let context = database.context
        
        var output: [Entity] = []
        
        switch self
        {
        case .add(let entityType, let name):
            let entity = entityType.insertNewEntity(into: context, name: name)
            output = [entity]
            workspace.insert(entity, at: 0)
        case .setName(let entity, let name):
            if let entity = entity as? SymbolNamed {
                let symbol = Symbol(context: context, name: name)
                entity.symbolName = symbol
            }
            output = [entity]
        case .hide(let entity):
            entity.isHidden = true
            output = [entity]
        case .unhide(let entity):
            entity.isHidden = false
            output = [entity]
        case .view(let printable):
            print(printable.fullDescription)
            if let entity = printable as? Selectable
            {
                output = entity.selection
            }
        case .delete(let entity):
            context.delete(entity)
            output = [entity]
        case .pin(entity: let entity):
            entity.isPinned = true
            output = [entity]
        case .unpin(entity: let entity):
            entity.isPinned = false
            output = [entity]
        case .select(let index):
            guard index < workspace.count else { return [] }
            
            let item = workspace[index]
            workspace.remove(at: index)
            workspace.insert(item, at: 0)
            if let item = item as? Selectable
            {
                output = item.selection
            }
            else
            {
                output = [item]
            }
        case .choose(let index, let lastResult):
            let item = lastResult[index]
            workspace.insert(item, at: 0)
            output = [item]
        case .pinned:
            output = runPinned(context: context)
        case .library:
            output = runLibrary(context: context)
        case .all(let entityType):
            output = runAll(entityType: entityType, context: context)
        case .unbalanced:
            output = runUnbalanced(context: context)
        case .priority:
            output = runPriority(context: context)
        case .events:
            output = runEvents(context: context)
        case .flows:
            output = runFlowsNeedingCompletion(context: context)
        case .running:
            output = allRunningFlows(context: context)
        case .nuke:
            database.clear()
        case .clear:
            workspace.removeAll()
        case .setStockType(let stock, let type):
            stock.source?.valueType = type
            output = [stock]
        case .setCurrent(let stock, let current):
            stock.current = current
            output = [stock]
        case .setIdeal(let stock, let ideal):
            stock.target = ideal
            output = [stock]
        case .setMin(let stock, let min):
            stock.min = min
            output = [stock]
        case .setMax(let stock, let max):
            stock.max = max
            output = [stock]
        case .setUnit(let stock, let unit):
            stock.unit = unit
            output = [stock]
        case .linkOutflow(let stock, let flow):
            stock.addToOutflows(flow)
            output = [stock]
        case .linkInflow(let stock, let flow):
            stock.addToInflows(flow)
            output = [stock]
        case .unlinkOutflow(let stock, let flow):
            stock.removeFromOutflows(flow)
            output = [stock]
        case .unlinkInflow(let stock, let flow):
            stock.removeFromInflows(flow)
            output = [stock]
        case .linkStockEvent(let stock, let event):
            stock.addToEvents(event)
            output = [stock]
        case .unlinkStockEvent(let stock, let event):
            stock.removeFromEvents(event)
            output = [stock]
        case .setAmount(let flow, let amount):
            flow.amount = amount
            output = [flow]
        case .setDelay(let flow, let delay):
            flow.delay = delay
            output = [flow]
        case .setDuration(let flow, let duration):
            flow.duration = duration
            output = [flow]
        case .setRequires(let flow, let requires):
            flow.requiresUserCompletion = requires
            output = [flow]
        case .setFrom(let flow, let stock):
            flow.from = stock
            output = [flow]
        case .setTo(let flow, let stock):
            flow.to = stock
            output = [flow]
        case .run(let flow):
            flow.run(fromUser: true)
            output = [flow]
        case .finish(let flow):
            flow.amountRemaining = 0
            flow.isRunning = false
            output = [flow]
        case .linkFlowEvent(let flow, let event):
            flow.addToEvents(event)
            output = [flow]
        case .unlinkFlowEvent(let flow, let event):
            flow.removeFromEvents(event)
            output = [flow]
        case .setIsActive(let event, let isActive):
            event.isActive = isActive
            output = [event]
        case .linkCondition(let event, let condition):
            event.addToConditions(condition)
            output = [event]
        case .setConditionType(let event, let type):
            event.conditionType = type
            output = [event]
        case .linkFlow(let event, let flow):
            event.addToFlows(flow)
            output = [event]
        case .setCooldown(let event, let cooldown):
            event.cooldownSeconds = cooldown
            output = [event]
        case .setComparison(let condition, let comparison, let type):
            condition.setComparison(comparison, type: type)
            output = [condition]
        case .setLeftHandSource(let condition, let source):
            condition.leftHand = source
            output = [condition]
        case .setLeftHandStock(let condition, let stock):
            condition.leftHand = stock.source
            output = [condition]
        case .setLeftHandNumber(let condition, let number):
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.leftHand = source
            output = [condition]
        case .setRightHandSource(let condition, let source):
            condition.rightHand = source
            output = [condition]
        case .setRightHandStock(let condition, let stock):
            condition.rightHand = stock.source
            output = [condition]
        case .setRightHandNumber(let condition, let number):
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.rightHand = source
            output = [condition]
        case .linkSystemFlow(system: let system, flow: let flow):
            system.addToFlows(flow)
        case .unlinkSystemFlow(system: let system, flow: let flow):
            system.removeFromFlows(flow)
        case .linkSystemStock(system: let system, stock: let stock):
            system.addToStocks(stock)
        case .unlinkSystemStock(system: let system, stock: let stock):
            system.removeFromStocks(stock)
        }
        
        context.quickSave()
        
        return output
    }
    
    static func getEntity<T: Entity>(in workspace: [Entity], at index: Int = 0, warn: Bool = true) -> T?
    {
        guard workspace.count > index else
        {
            if warn { print("The index \(index) is out of bounds.") }
            return nil
        }
        
        guard let entity = workspace[index] as? T else
        {
            if warn { print("The entity at index \(index) was not a(n) \(T.self)") }
            return nil
        }
        
        return entity
    }
    
    static func getEntities<A: Entity, B: Entity>(commandData: CommandData, workspace: [Entity], warn: Bool = true) -> (A, B)?
    {
        guard let index = commandData.getIndex() else
        {
            if warn { print("No index.") }
            return nil
        }
        
        let first: A? = getEntity(in: workspace, at: 0, warn: warn)
        let second: B? = getEntity(in: workspace, at: index, warn: warn)
        
        guard let f = first, let s = second else
        {
            return nil
        }
        
        return (f, s)
    }
    
    static func getEntityAndDouble<T: Entity>(commandData: CommandData, workspace: [Entity], warn: Bool = false) -> (T, Double)?
    {
        guard let argument = commandData.arguments.first, let number = Double(argument) else
        {
            if warn { print("Please enter a number.") }
            return nil
        }
        
        guard let entity = workspace.first as? T else
        {
            if warn { print("No entity, or entity isn't a \(T.self)") }
            return nil
        }
        
        return (entity, number)
    }

    static func getEntityAndBool<T: Entity>(commandData: CommandData, workspace: [Entity]) -> (T, Bool)?
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

extension Command
{
    func allRunningFlows(context: Context) -> [Entity]
    {
        let result = Flow.runningFlows(in: context)
        
        for flow in result
        {
            print(flow.runningDescription)
        }
        
        return result
    }
    
    func runPinned(context: Context) -> [Entity]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        let result = (try? context.fetch(request)) ?? []
        let pins = result.compactMap { $0 as? Pinnable }
        print("Pins: \(pins)")
        return pins
    }
    
    func runLibrary(context: Context) -> [Entity]
    {
        for type in EntityType.libraryVisible
        {
            let count = type.count(in: context)
            print("\(type.icon.text) \(type.title) (\(count))")
        }
        return []
    }
    
    func runAll(entityType: EntityType, context: Context) -> [Entity]
    {
        let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
        let result = (try? context.fetch(request)) ?? []
        guard result.count > 0 else {
            print("No results")
            return []
        }
        
        for item in result.enumerated()
        {
            if let entity = item.element as? Named
            {
                let icon = entityType.icon.text
                print("\(item.offset): \(icon) \(entity.title)")
            }
        }
        
        return result as? [Entity] ?? []
    }
    
    func runUnbalanced(context: Context) -> [Entity]
    {
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        let unbalanced = result.filter { $0.percentIdeal < Stock.thresholdPercent }
        print("Unbalanced: \(unbalanced)")
        return unbalanced
    }
    
    func runPriority(context: Context) -> [Entity]
    {
        var suggested: Set<Flow> = []
        let allStocks: [Stock] = Stock.all(context: context)
        let unbalancedStocks = allStocks.filter { stock in
            stock.percentIdeal <= Stock.thresholdPercent
        }
        
        for stock in unbalancedStocks
        {
            var bestFlow: Flow?
            var bestPercentIdeal: Double = 0
            
            let allFlows = (stock.unwrappedInflows + stock.unwrappedOutflows).filter { !$0.isRunning }
            
            for flow in allFlows
            {
                let amount: Double
                
                // TODO: Could clean this up a bit
                if stock.unwrappedInflows.contains(where: { $0 == flow })
                {
                    amount = flow.amount
                }
                else if stock.unwrappedOutflows.contains(where: { $0 == flow })
                {
                    amount = -flow.amount
                }
                else
                {
                    print("Something's wrong: flow wasn't part of inflows or outflows")
                    fatalError()
                }
                
                let projectedCurrent = min(stock.max, stock.current + amount)
                let projectedPercentIdeal = Double.percentDelta(
                    a: projectedCurrent,
                    b: stock.target,
                    minimum: stock.min,
                    maximum: stock.max)
                if projectedPercentIdeal > bestPercentIdeal
                {
                    bestFlow = flow
                    bestPercentIdeal = projectedPercentIdeal
                }
            }
            
            if let flow = bestFlow
            {
                suggested.insert(flow)
            }
        }
        
        print("Priority: \(suggested)")
        return Array(suggested)
    }
    
    func runEvents(context: Context) -> [Entity]
    {
        let events = Event.activeAndSatisfiedEvents(context: context)
        for event in events
        {
            print(event)
        }
        return events
    }
    
    func runFlowsNeedingCompletion(context: Context) -> [Entity]
    {
        let flows: [Flow] = Flow.all(context: context)
        let flowsNeedingCompletion = flows.filter { flow in
            flow.needsUserExecution
        }
        for flow in flowsNeedingCompletion {
            print(flow)
        }
        return flowsNeedingCompletion
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
            return nil
        }
        
        return arguments[index...].joined(separator: " ")
    }
    
    func getIndex() -> Int?
    {
        guard var first = arguments.first else
        {
            print("No arguments.")
            return nil
        }
        
        // For the cases where we want a wild-card to distinguish it from a number input
        if first.first == "$"
        {
            first.removeFirst()
        }
        
        guard let number = Int(first) else
        {
            print("First argument was not an integer.")
            return nil
        }
        
        return number
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
    
    func getConditionType() -> ConditionType?
    {
        guard let string = arguments.first else
        {
            print("Please provide a condition type: `all` or `any`")
            return nil
        }
        
        return ConditionType(string)
    }
    
    func getComparisonType() -> ComparisonType?
    {
        guard let string = arguments.first else
        {
            print("Please provide a comparison type: `bool`, `date`, or `number`")
            return nil
        }
        
        return ComparisonType(string: string)
    }
    
    func getArgument(at index: Int) -> String?
    {
        guard arguments.count > index else
        {
            print("Not enough arguments in \(arguments) to get an argument at index \(index)")
            return nil
        }
        
        return arguments[index]
    }
}
