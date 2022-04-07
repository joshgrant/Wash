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
    
    func runPinned(context: Context, shouldPrint: Bool = true) -> [Entity]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        let result = (try? context.fetch(request)) ?? []
        let pins = result.compactMap { $0 as? Pinnable }
        if shouldPrint { print("Pins: \(pins)") }
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
                print("\(item.offset): \(entity)")
            }
        }
        
        return result as? [Entity] ?? []
    }
    
    func runUnbalanced(context: Context, shouldPrint: Bool = true) -> [Entity]
    {
        let requestStock: NSFetchRequest<Stock> = Stock.fetchRequest()
        let resultStock = (try? context.fetch(requestStock)) ?? []
        let unbalancedStocks = resultStock.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Stocks: \(unbalancedStocks)") }
        
        let requestSystem: NSFetchRequest<System> = System.fetchRequest()
        let resultSystem = (try? context.fetch(requestSystem)) ?? []
        let unbalancedSystems = resultSystem.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Systems: \(unbalancedSystems)") }
        
        return unbalancedStocks + unbalancedSystems
    }
    
    func runPriority(context: Context, shouldPrint: Bool = true) -> [Entity]
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
        
        if shouldPrint { print("Priority: \(suggested)") }
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
