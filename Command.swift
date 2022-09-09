//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation
import CoreData

class Command
{
    // MARK: - Variables
    
    var context: Context
    var command: String
    var arguments: [String]
    var workspace: Workspace
    
    // MARK: - Initialization
    
    init?(input: String, workspace: Workspace, context: Context)
    {
        let (command, arguments) = Self.parse(input: input)
        self.command = command
        self.arguments = arguments
        self.workspace = workspace
        self.context = context
    }
    
    static func parse(input: String) -> (String, [String])
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
        
        return (command, arguments)
    }
    
    // MARK: - Public functions
    
    func run(database: Database) -> [Entity]
    {
        // Parse the command....
        database.context.quickSave()
        return []
    }
}

// MARK: - Argument parsing

private extension Command
{
    func entityType() throws -> EntityType
    {
        guard arguments.count > 0 else { throw ParsingError.noArguments }
        return try EntityType(string: arguments[0])
    }
    
    func name(startingAt index: Int = 0) throws -> String
    {
        guard arguments.count > index else { throw ParsingError.indexOutsideOfArgumentsBounds(index) }
        return arguments[index...].joined(separator: " ")
    }
    
    func index() throws -> Int
    {
        guard var first = arguments.first else { throw ParsingError.noArguments }
        
        // For the cases where we want a wild-card to distinguish it from a number input
        if first.first == "$"
        {
            first.removeFirst()
        }
        
        guard let number = Int(first) else { throw ParsingError.argumentDidNotMatchType(Int.self) }
        return number
    }
    
    func sourceValueType() throws -> SourceValueType
    {
        guard let first = arguments.first else { throw ParsingError.noArguments }
        return try SourceValueType(string: first.lowercased())
    }
    
    func value<T: LosslessStringConvertible>() throws -> T
    {
        guard let first = arguments.first else { throw ParsingError.noArguments }
        guard let number = T(first) else { throw ParsingError.argumentDidNotMatchType(T.self) }
        return number
    }
    
    func conditionType() throws -> ConditionType
    {
        guard let string = arguments.first else { throw ParsingError.noArguments }
        return try ConditionType(string: string)
    }
    
    func comparisonType() throws -> ComparisonType
    {
        guard let string = arguments.first else { throw ParsingError.noArguments }
        return try ComparisonType(string: string)
    }
    
    func argument(at index: Int) throws -> String
    {
        guard arguments.count > index else { throw ParsingError.indexOutsideOfArgumentsBounds(index) }
        return arguments[index]
    }
}

// MARK: - Commands

private extension Command
{
    func help() throws -> [Entity]
    {
        print("Sorry, no help is available at this time.")
        return []
    }
    
    func add() throws -> [Entity]
    {
        let entityType = try entityType()
        let name = try name(startingAt: 1)
        
        let entity = entityType.insertNewEntity(into: context, name: name)
        workspace.entities.insert(entity, at: 0)
        
        return [entity]
    }
    
    func setName() throws -> [Entity]
    {
        let entity: SymbolNamed = try workspace.first()
        let name = try name()
        
        let symbol = Symbol(context: context, name: name)
        entity.symbolName = symbol
        
        return [entity]
    }
    
    func hide() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        entity.isHidden = true
        return [entity]
    }
    
    func unhide() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        entity.isHidden = false
        return [entity]
    }
    
    func view() throws -> [Entity]
    {
        let entity: Printable = try workspace.first()
        print(entity.fullDescription)
        
        if let entity = entity as? Selectable
        {
            return entity.selection
        }
        else if let entity = entity as? Entity
        {
            return [entity]
        }
        else
        {
            throw ParsingError.argumentDidNotMatchType(Entity.self)
        }
    }
    
    func delete() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        context.delete(entity)
        return [entity]
    }
    
    func pin() throws -> [Entity]
    {
        let entity: Pinnable = try workspace.first()
        entity.isPinned = true
        return [entity]
    }
    
    func unpin() throws -> [Entity]
    {
        let entity: Pinnable = try workspace.first()
        entity.isPinned = false
        return [entity]
    }
    
    func select() throws -> [Entity]
    {
        let index = try index()
        let entity: Entity = try workspace.entity(at: index)
        workspace.entities.remove(at: index)
        workspace.entities.insert(entity, at: 0)
        
        if let entity = entity as? Selectable
        {
            return entity.selection
        }
        else
        {
            return [entity]
        }
    }
    
    func choose() throws -> [Entity]
    {
        let index = try index()
        
        guard index < workspace.lastResult.count else
        {
            throw ParsingError.lastResultIndexOutOfBounds(index)
        }
        
        let entity = workspace.lastResult[index]
        workspace.entities.insert(entity, at: 0)
        
        return [entity]
    }
    
    func history() throws -> [Entity]
    {
        let entity: Historable = try workspace.first()
        
        guard let history = entity.history else
        {
            throw ParsingError.noHistory
        }
        
        for item in history
        {
            print(item)
        }
        
        if let allObjects = history.allObjects as? [Entity]
        {
            return allObjects
        }
        else
        {
            return []
        }
    }
    
    func pinned(shouldPrint: Bool) -> [Entity]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        let result = (try? context.fetch(request)) ?? []
        let pins = result.compactMap { $0 as? Pinnable }
        if shouldPrint { print("Pins: \(pins)") }
        return pins
    }
    
    func library() -> [Entity]
    {
        for type in EntityType.libraryVisible
        {
            let count = type.count(in: context)
            print("\(type.icon.text) \(type.title) (\(count))")
        }
        
        return []
    }
    
    func all() throws -> [Entity]
    {
        let entityType = try entityType()
        
        let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
        request.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
        
        let result = try context.fetch(request)
        
        guard result.count > 0 else
        {
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
    
    func unbalanced(shouldPrint: Bool = true) -> [Entity]
    {
        let requestStock: NSFetchRequest<Stock> = Stock.fetchRequest()
        requestStock.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        let resultStock = (try? context.fetch(requestStock)) ?? []
        let unbalancedStocks = resultStock.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Stocks: \(unbalancedStocks)") }
        
        let requestSystem: NSFetchRequest<System> = System.fetchRequest()
        requestSystem.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        let resultSystem = (try? context.fetch(requestSystem)) ?? []
        let unbalancedSystems = resultSystem.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Systems: \(unbalancedSystems)") }
        
        return unbalancedStocks + unbalancedSystems
    }
    
    func priority(shouldPrint: Bool = true) -> [Entity]
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
                if flow.isHidden { continue }
                
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
    
    func dashboard()
    {
        let pinned = pinned(shouldPrint: false)
        let unbalanced = unbalanced(shouldPrint: false)
        let priority = priority(shouldPrint: false)
        
        print("Pinned")
        print("------------")
        for pin in pinned {
            print(pin)
        }
        print("")
        print("Unbalanced")
        print("------------")
        for item in unbalanced {
            print(item)
        }
        print("")
        print("Priority")
        print("------------")
        for item in priority {
            print(item)
        }
        print("------------")
    }
    
    func suggest()
    {
        //            // Should we pin an item we view often?
        //            // Should we find a flow to balance an unbalanced stock?
        //            // Should we run a priority flow?
    }
    
    func events() -> [Entity]
    {
        let events = Event.activeAndSatisfiedEvents(context: context)
        for event in events
        {
            print(event)
        }
        return events
    }
    
    func flows() -> [Entity]
    {
        let flows: [Flow] = Flow.all(context: context)
        let flowsNeedingCompletion = flows.filter { flow in
            flow.needsUserExecution && !flow.isHidden && flow.deletedDate == nil
        }
        for flow in flowsNeedingCompletion {
            print(flow)
        }
        return flowsNeedingCompletion
    }
    
    func running() -> [Entity]
    {
        let result = Flow.runningFlows(in: context)
        
        for flow in result
        {
            if flow.isHidden { continue }
            print(flow.runningDescription)
        }
        
        return result
    }
    
    func hidden() -> [Entity]
    {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "isHidden == true")
        let result = (try? context.fetch(request)) ?? []
        print(result)
        return result
    }
    
    func quit()
    {
        // TODO: Communicate to quit the application
    }
    
    func nuke()
    {
        database.clear()
    }
    
    func clear()
    {
        workspace.entities.removeAll()
    }
    
    func setStockType() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let type = try sourceValueType()
        stock.source?.valueType = type
        return [stock]
    }
    
    func setCurrent() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.current = number
        return [stock]
    }
    
    func setIdeal() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.target = number
        return [stock]
    }
    
    func setMin() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.min = number
        return [stock]
    }
    
    func setMax() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.max = number
        return [stock]
    }
    
    func setUnit() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let unit: Unit = try workspace.entity(at: index)
        stock.unit = unit
        return [stock]
    }
    
    func linkOutflow() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.addToOutflows(flow)
        return [stock]
    }
    
    func linkInflow() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.addToInflows(flow)
        return [stock]
    }
    
    func unlinkOutflow() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.removeFromOutflows(flow)
        return [stock]
    }
    
    func unlinkInflow() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.removeFromInflows(flow)
        return [stock]
    }
    
    func setAmount() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let amount: Double = try value()
        
        guard amount > 0 else { throw ParsingError.flowAmountInvalid(amount) }
        flow.amount = amount
        return [flow]
    }
    
    func setDelay() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let delay: Double = try value()
        flow.delay = delay
        return [flow]
    }
    
    func setDuration() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let duration: Double = try value()
        flow.duration = duration
        return [flow]
    }
    
    func setRequires() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let requires: Bool = try value()
        flow.requiresUserCompletion = requires
        return [flow]
    }
    
    func setFrom() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.first()
        let stock: Stock = try workspace.entity(at: index)
        flow.from = stock
        return [flow]
    }
    
    func setTo() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.first()
        let stock: Stock = try workspace.entity(at: index)
        flow.to = stock
        return [flow]
    }
    
    func run() throws -> [Entity]
    {
        if let flow: Flow = try? workspace.first()
        {
            flow.run(fromUser: true)
            return [flow]
        }
        else if let process: Process = try? workspace.first()
        {
            process.run()
            return [process]
        }
        else
        {
            throw ParsingError.notRunnable
        }
    }
    
    func finish() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        flow.amountRemaining = 0
        flow.isRunning = false
        return [flow]
    }
    
    func setRepeats() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let repeats: Bool = try value()
        flow.repeats = repeats
        return [flow]
    }
    
    func setActive() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let active: Bool = try value()
        event.isActive = active
        return [event]
    }
    
    func linkCondition() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.first()
        let condition: Condition = try workspace.entity(at: index)
        event.addToConditions(condition)
        return [event]
    }
    
    func unlinkCondition() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.first()
        let condition: Condition = try workspace.entity(at: index)
        event.removeFromConditions(condition)
        return [event]
    }
    
    func setConditionType() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let conditionType = try conditionType()
        event.conditionType = conditionType
        return [event]
    }
    
    func setCooldown() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let cooldown: Double = try value()
        event.cooldownSeconds = cooldown
        return [event]
    }
    
    func setComparison() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        let comparison = try comparisonType()
        let type = try argument(at: 1)
        condition.setComparison(comparison, type: type)
        return [condition]
    }
    
    func setLeftHand() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        
        if let number: Double = try? value()
        {
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.leftHand = source
            return [condition]
        }
        else if
            let index = try? index(),
            let source: Source = try workspace.entity(at: index)
        {
            condition.leftHand = source
            return [condition]
        }
        else if
            let index = try? index(),
            let stock: Stock = try workspace.entity(at: index)
        {
            condition.leftHand = stock.source
            return [condition]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func setRightHand() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        
        if let number: Double = try? value()
        {
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.rightHand = source
            return [condition]
        }
        else if
            let index = try? index(),
            let source: Source = try workspace.entity(at: index)
        {
            condition.rightHand = source
            return [condition]
        }
        else if
            let index = try? index(),
            let stock: Stock = try workspace.entity(at: index)
        {
            condition.rightHand = stock.source
            return [condition]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func linkFlow() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.entity(at: index)
        
        if let event: Event = try? workspace.first()
        {
            event.addToFlows(flow)
            return [event]
        }
        else if let system: System = try? workspace.first()
        {
            system.addToFlows(flow)
            return [system]
        }
        else if let process: Process = try? workspace.first()
        {
            process.addToFlows(flow)
            return [process]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func unlinkFlow() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.entity(at: index)
        
        if let event: Event = try? workspace.first()
        {
            event.removeFromFlows(flow)
            return [event]
        }
        else if let system: System = try? workspace.first()
        {
            system.removeFromFlows(flow)
            return [system]
        }
        else if let process: Process = try? workspace.first()
        {
            process.removeFromFlows(flow)
            return [process]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func linkStock() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.entity(at: index)
        let system: System = try workspace.first()
        system.addToStocks(stock)
        return [system]
    }
    
    func unlinkStock() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.entity(at: index)
        let system: System = try workspace.first()
        system.removeFromStocks(stock)
        return [system]
    }
    
    func linkEvent() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.entity(at: index)
        
        if let flow: Flow = try? workspace.first()
        {
            flow.addToEvents(event)
            return [flow]
        }
        else if let stock: Stock = try? workspace.first()
        {
            stock.addToEvents(event)
            return [stock]
        }
        else if let process: Process = try? workspace.first()
        {
            process.addToEvents(event)
            return [process]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func unlinkEvent() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.entity(at: index)
        
        if let flow: Flow = try? workspace.first()
        {
            flow.removeFromEvents(event)
            return [flow]
        }
        else if let stock: Stock = try? workspace.first()
        {
            stock.removeFromEvents(event)
            return [stock]
        }
        else if let process: Process = try? workspace.first()
        {
            process.removeFromEvents(event)
            return [process]
        }
        else
        {
            throw ParsingError.workspaceEntityCannotPerformThisOperation
        }
    }
    
    func linkProcess() throws -> [Entity]
    {
        let index = try index()
        let subprocess: Process = try workspace.entity(at: index)
        let process: Process = try workspace.first()
        process.addToSubProcesses(subprocess)
        return [process]
    }
    
    func unlinkProcess() throws -> [Entity]
    {
        let index = try index()
        let subprocess: Process = try workspace.entity(at: index)
        let process: Process = try workspace.first()
        process.removeFromSubProcesses(subprocess)
        return [process]
    }
    
    func booleanStockFlow() throws -> [Entity]
    {
        let name = try name()
        
        let stock = EntityType.stock.insertNewEntity(into: context, name: name) as! Stock
        stock.current = 0
        stock.target = 1
        stock.max = 1
        stock.valueType = .boolean
        
        // Check as in "check off a box"
        let checkFlow = EntityType.flow.insertNewEntity(into: context, name: "Check: " + name) as! Flow
        checkFlow.amount = 1
        checkFlow.duration = 1
        checkFlow.delay = 0
        checkFlow.from = ContextPopulator.sourceStock(context: context)
        checkFlow.to = stock
        
        let uncheckFlow = EntityType.flow.insertNewEntity(into: context, name: "Uncheck: " + name) as! Flow
        uncheckFlow.amount = 1
        uncheckFlow.duration = 0
        uncheckFlow.delay = 0
        uncheckFlow.from = stock
        uncheckFlow.to = ContextPopulator.sinkStock(context: context)
        
        workspace.entities.insert(stock, at: 0)
        workspace.entities.insert(checkFlow, at: 2)
        workspace.entities.insert(uncheckFlow, at: 2)
        
        return [stock, checkFlow, uncheckFlow]
    }
}
