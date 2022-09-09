//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation
import CoreData

protocol TextRepresentable
{
    var names: [String] { get }
}

open class Command: TextRepresentable
{
    // MARK: - Variables
    
    open var names: [String] { [] }
    
    var database: Database
    
    @available(*, deprecated)
    var input: String
    
    var command: String
    var arguments: [String]
    var workspace: Workspace
    
    // MARK: - Initialization
    
    init?(input: String, workspace: Workspace, database: Database)
    {
        let (command, arguments) = Self.parse(input: input)
        self.input = input
        self.command = command
        self.arguments = arguments
        self.workspace = workspace
        self.database = database
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
    
    open func run() throws -> [Entity]
    {
        // Parse the command....
        database.context.quickSave()
        return []
    }
}

extension Command
{
    static var allCases: [Command.Type] = [
        CommandAdd.self,
        CommandSetName.self,
        CommandHide.self,
        CommandUnhide.self,
        CommandView.self,
        CommandDelete.self,
        CommandPin.self,
        CommandUnpin.self,
        CommandSelect.self,
        CommandChoose.self,
        CommandHistory.self,
        CommandPinned.self,
        CommandLibrary.self,
        CommandAll.self,
        CommandUnbalanced.self,
        CommandPriority.self,
        CommandDashboard.self,
        CommandSuggest.self,
        CommandEvents.self,
        CommandFlows.self,
        CommandRunning.self,
        CommandHidden.self,
        CommandQuit.self,
        CommandNuke.self,
        CommandClear.self,
        CommandSetStockType.self,
        CommandSetCurrent.self,
        CommandSetIdeal.self,
        CommandSetMin.self,
        CommandSetMax.self,
        CommandSetUnit.self,
        CommandLinkOutflow.self,
        CommandLinkInflow.self,
        CommandUnlinkOutflow.self,
        CommandUnlinkInflow.self,
        CommandSetAmount.self,
        CommandSetDelay.self,
        CommandSetDuration.self,
        CommandSetRequires.self,
        CommandSetFrom.self,
        CommandSetTo.self,
        CommandFinish.self,
        CommandSetRepeats.self,
        CommandSetActive.self,
        CommandLinkCondition.self,
        CommandUnlinkCondition.self,
        CommandSetConditionType.self,
        CommandSetCooldown.self,
        CommandSetComparison.self,
        CommandSetLeftHand.self,
        CommandSetRightHand.self,
        CommandLinkFlow.self,
        CommandUnlinkFlow.self,
        CommandLinkStock.self,
        CommandUnlinkStock.self,
        CommandLinkEvent.self,
        CommandUnlinkEvent.self,
        CommandLinkProcess.self,
        CommandUnlinkProcess.self,
        CommandBooleanStockFlow.self,
    ]
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

class CommandHelp: Command
{
    override var names: [String]
    {
        ["help"]
    }
    
    override func run() -> [Entity] {
        print("Sorry, no help is available at this time.")
        return []
    }
}

class CommandRun: Command
{
    override var names: [String]
    {
        ["run"]
    }
    
    override func run() throws -> [Entity]
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
}

class CommandAdd: Command
{
    
    override var names: [String] { ["add"] }
    
    override func run() throws -> [Entity]
    {
        let entityType = try entityType()
        let name = try name(startingAt: 1)
        
        let entity = entityType.insertNewEntity(into: database.context, name: name)
        workspace.entities.insert(entity, at: 0)
        
        return [entity]
    }
}

class CommandSetName: Command
{
    
    override var names: [String] { ["setName"] }
    
    override func run() throws -> [Entity]
    {
        let entity: SymbolNamed = try workspace.first()
        let name = try name()
        
        let symbol = Symbol(context: database.context, name: name)
        entity.symbolName = symbol
        
        return [entity]
    }
}

class CommandHide: Command
{
    
    override var names: [String] { ["hide"] }
    
    override func run() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        entity.isHidden = true
        return [entity]
    }
}

class CommandUnhide: Command
{
    
    override var names: [String] { ["unhide"] }
    
    override func run() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        entity.isHidden = false
        return [entity]
    }
}

class CommandView: Command
{
    
    override var names: [String] { ["view"] }
    
    override func run() throws -> [Entity]
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
}

class CommandDelete: Command
{
    
    override var names: [String] { ["delete"] }
    
    override func run() throws -> [Entity]
    {
        let entity: Entity = try workspace.first()
        database.context.delete(entity)
        return [entity]
    }
}

class CommandPin: Command
{
    
    override var names: [String] { ["pin"] }
    
    override func run() throws -> [Entity]
    {
        let entity: Pinnable = try workspace.first()
        entity.isPinned = true
        return [entity]
    }
}

class CommandUnpin: Command
{
    
    override var names: [String] { ["unpin"] }
    
    override func run() throws -> [Entity]
    {
        let entity: Pinnable = try workspace.first()
        entity.isPinned = false
        return [entity]
    }
}

class CommandSelect: Command
{
    
    override var names: [String] { ["select"] }
    
    override func run() throws -> [Entity]
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
}

class CommandChoose: Command
{
    
    override var names: [String] { ["choose"] }
    
    override func run() throws -> [Entity]
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
}

class CommandHistory: Command
{
    
    override var names: [String] { ["history"] }
    
    override func run() throws -> [Entity]
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
}

class CommandPinned: Command
{
    override var names: [String] { ["pinned"] }
    
    var shouldPrint: Bool = true
    
    override func run() throws -> [Entity]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: database.context)
        let result = (try? database.context.fetch(request)) ?? []
        let pins = result.compactMap { $0 as? Pinnable }
        if shouldPrint { print("Pins: \(pins)") }
        return pins
    }
}

class CommandLibrary: Command
{
    
    override var names: [String] { ["library"] }
    
    override func run() throws -> [Entity]
    {
        for type in EntityType.libraryVisible
        {
            let count = type.count(in: database.context)
            print("\(type.icon.text) \(type.title) (\(count))")
        }
        
        return []
    }
}

class CommandAll: Command
{
    
    override var names: [String] { ["all"] }
    
    override func run() throws -> [Entity]
    {
        let entityType = try entityType()
        
        let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
        request.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
        
        let result = try database.context.fetch(request)
        
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
}

class CommandUnbalanced: Command
{
    
    override var names: [String] { ["unbalanced"] }
    
    var shouldPrint: Bool = true
    
    override func run() -> [Entity]
    {
        let requestStock: NSFetchRequest<Stock> = Stock.fetchRequest()
        requestStock.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        let resultStock = (try? database.context.fetch(requestStock)) ?? []
        let unbalancedStocks = resultStock.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Stocks: \(unbalancedStocks)") }
        
        let requestSystem: NSFetchRequest<System> = System.fetchRequest()
        requestSystem.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
        let resultSystem = (try? database.context.fetch(requestSystem)) ?? []
        let unbalancedSystems = resultSystem.filter { $0.percentIdeal < Stock.thresholdPercent }
        if shouldPrint { print("Unbalanced Systems: \(unbalancedSystems)") }
        
        return unbalancedStocks + unbalancedSystems
    }
}

class CommandPriority: Command
{
    
    override var names: [String] { ["priority"] }
    
    var shouldPrint: Bool = true
    
    override func run() -> [Entity]
    {
        var suggested: Set<Flow> = []
        let allStocks: [Stock] = Stock.all(context: database.context)
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
}

class CommandDashboard: Command
{
    override var names: [String] { ["dashboard"] }
    
    override func run() throws -> [Entity]
    {
        let pinned = CommandPinned(input: input, workspace: workspace, database: database)
        pinned?.shouldPrint = false
        
        let unbalanced = CommandUnbalanced(input: input, workspace: workspace, database: database)
        unbalanced?.shouldPrint = false
        let priority = CommandPriority(input: input, workspace: workspace, database: database)
        priority?.shouldPrint = false
        
        print("Pinned")
        print("------------")
        for pin in pinned?.run() {
            print(pin)
        }
        print("")
        print("Unbalanced")
        print("------------")
        for item in unbalanced?.run() {
            print(item)
        }
        print("")
        print("Priority")
        print("------------")
        for item in priority?.run() {
            print(item)
        }
        print("------------")
    }
}

class CommandSuggest: Command
{
    
    override var names: [String] { ["suggest"] }
    
    override func run() throws -> [Entity]
    {
        //            // Should we pin an item we view often?
        //            // Should we find a flow to balance an unbalanced stock?
        //            // Should we run a priority flow?
    }
}

class CommandEvents: Command
{
    
    override var names: [String] { ["events"] }
    
    override func run() -> [Entity]
    {
        let events = Event.activeAndSatisfiedEvents(context: database.context)
        for event in events
        {
            print(event)
        }
        return events
    }
}

class CommandFlows: Command
{
    
    override var names: [String] { ["flows"] }
    
    override func run() -> [Entity]
    {
        let flows: [Flow] = Flow.all(context: database.context)
        let flowsNeedingCompletion = flows.filter { flow in
            flow.needsUserExecution && !flow.isHidden && flow.deletedDate == nil
        }
        for flow in flowsNeedingCompletion {
            print(flow)
        }
        return flowsNeedingCompletion
    }
}

class CommandRunning: Command
{
    
    override var names: [String] { ["running"] }
    
    override func run() -> [Entity]
    {
        let result = Flow.runningFlows(in: database.context)
        
        for flow in result
        {
            if flow.isHidden { continue }
            print(flow.runningDescription)
        }
        
        return result
    }
}

class CommandHidden: Command
{
    
    override var names: [String] { ["hidden"] }
    
    override func run() -> [Entity]
    {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "isHidden == true")
        let result = (try? database.context.fetch(request)) ?? []
        print(result)
        return result
    }
}

class CommandQuit: Command
{
    
    override var names: [String] { ["quit"] }
    
    override func run() throws -> [Entity]
    {
        // TODO: Communicate to quit the application
    }
}

class CommandNuke: Command
{
    
    override var names: [String] { ["nuke"] }
    
    override func run() throws -> [Entity]
    {
        database.clear()
    }
}

class CommandClear: Command
{
    
    override var names: [String] { ["clear"] }
    
    override func run() throws -> [Entity]
    {
        workspace.entities.removeAll()
    }
}

class CommandSetStockType: Command
{
    
    override var names: [String] { ["setStockType"] }
    
    override func run() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let type = try sourceValueType()
        stock.source?.valueType = type
        return [stock]
    }
}

class CommandSetCurrent: Command
{
    
    override var names: [String] { ["setCurrent"] }
    
    override func run() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.current = number
        return [stock]
    }
}

class CommandSetIdeal: Command
{
    
    override var names: [String] { ["setIdeal"] }
    
    override func run() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.target = number
        return [stock]
    }
}

class CommandSetMin: Command
{
    
    override var names: [String] { ["setMin"] }
    
    override func run() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.min = number
        return [stock]
    }
}

class CommandSetMax: Command
{
    
    override var names: [String] { ["setMax"] }
    
    override func run() throws -> [Entity]
    {
        let stock: Stock = try workspace.first()
        let number: Double = try value()
        stock.max = number
        return [stock]
    }
}

class CommandSetUnit: Command
{
    
    override var names: [String] { ["setUnit"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let unit: Unit = try workspace.entity(at: index)
        stock.unit = unit
        return [stock]
    }
}

class CommandLinkOutflow: Command
{
    
    override var names: [String] { ["linkOutflow"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.addToOutflows(flow)
        return [stock]
    }
}

class CommandLinkInflow: Command
{
    
    override var names: [String] { ["linkInflow"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.addToInflows(flow)
        return [stock]
    }
}

class CommandUnlinkOutflow: Command
{
    
    override var names: [String] { ["unlinkOutflow"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.removeFromOutflows(flow)
        return [stock]
    }
}

class CommandUnlinkInflow: Command
{
    
    override var names: [String] { ["unlinkInflow"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.first()
        let flow: Flow = try workspace.entity(at: index)
        stock.removeFromInflows(flow)
        return [stock]
    }
}

class CommandSetAmount: Command
{
    
    override var names: [String] { ["setAmount"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let amount: Double = try value()
        
        guard amount > 0 else { throw ParsingError.flowAmountInvalid(amount) }
        flow.amount = amount
        return [flow]
    }
}

class CommandSetDelay: Command
{
    
    override var names: [String] { ["setDelay"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let delay: Double = try value()
        flow.delay = delay
        return [flow]
    }
}

class CommandSetDuration: Command
{
    
    override var names: [String] { ["setDuration"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let duration: Double = try value()
        flow.duration = duration
        return [flow]
    }
}

class CommandSetRequires: Command
{
    
    override var names: [String] { ["setRequires"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let requires: Bool = try value()
        flow.requiresUserCompletion = requires
        return [flow]
    }
}

class CommandSetFrom: Command
{
    
    override var names: [String] { ["setFrom"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.first()
        let stock: Stock = try workspace.entity(at: index)
        flow.from = stock
        return [flow]
    }
}

class CommandSetTo: Command
{
    
    override var names: [String] { ["setTo"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let flow: Flow = try workspace.first()
        let stock: Stock = try workspace.entity(at: index)
        flow.to = stock
        return [flow]
    }
}

class CommandFinish: Command
{
    
    override var names: [String] { ["finish"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        flow.amountRemaining = 0
        flow.isRunning = false
        return [flow]
    }
}

class CommandSetRepeats: Command
{
    
    override var names: [String] { ["setRepeats"] }
    
    override func run() throws -> [Entity]
    {
        let flow: Flow = try workspace.first()
        let repeats: Bool = try value()
        flow.repeats = repeats
        return [flow]
    }
}

class CommandSetActive: Command
{
    
    override var names: [String] { ["setActive"] }
    
    override func run() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let active: Bool = try value()
        event.isActive = active
        return [event]
    }
}

class CommandLinkCondition: Command
{
    
    override var names: [String] { ["linkCondition"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.first()
        let condition: Condition = try workspace.entity(at: index)
        event.addToConditions(condition)
        return [event]
    }
}

class CommandUnlinkCondition: Command
{
    
    override var names: [String] { ["unlinkCondition"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.first()
        let condition: Condition = try workspace.entity(at: index)
        event.removeFromConditions(condition)
        return [event]
    }
}

class CommandSetConditionType: Command
{
    
    override var names: [String] { ["setConditionType"] }
    
    override func run() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let conditionType = try conditionType()
        event.conditionType = conditionType
        return [event]
    }
}

class CommandSetCooldown: Command
{
    
    override var names: [String] { ["setCooldown"] }
    
    override func run() throws -> [Entity]
    {
        let event: Event = try workspace.first()
        let cooldown: Double = try value()
        event.cooldownSeconds = cooldown
        return [event]
    }
}

class CommandSetComparison: Command
{
    
    override var names: [String] { ["setComparison"] }
    
    override func run() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        let comparison = try comparisonType()
        let type = try argument(at: 1)
        condition.setComparison(comparison, type: type)
        return [condition]
    }
}

class CommandSetLeftHand: Command
{
    
    override var names: [String] { ["setLeftHand"] }
    
    override func run() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        
        if let number: Double = try? value()
        {
            let source = Source(context: database.context)
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
}

class CommandSetRightHand: Command
{
    
    override var names: [String] { ["setRightHand"] }
    
    override func run() throws -> [Entity]
    {
        let condition: Condition = try workspace.first()
        
        if let number: Double = try? value()
        {
            let source = Source(context: database.context)
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
}

class CommandLinkFlow: Command
{
    
    override var names: [String] { ["linkFlow"] }
    
    override func run() throws -> [Entity]
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
}

class CommandUnlinkFlow: Command
{
    
    override var names: [String] { ["unlinkFlow"] }
    
    override func run() throws -> [Entity]
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
}

class CommandLinkStock: Command
{
    
    override var names: [String] { ["linkStock"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.entity(at: index)
        let system: System = try workspace.first()
        system.addToStocks(stock)
        return [system]
    }
}

class CommandUnlinkStock: Command
{
    
    override var names: [String] { ["unlinkStock"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let stock: Stock = try workspace.entity(at: index)
        let system: System = try workspace.first()
        system.removeFromStocks(stock)
        return [system]
    }
}

class CommandLinkEvent: Command
{
    
    override var names: [String] { ["linkEvent"] }
    
    override func run() throws -> [Entity]
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
}

class CommandUnlinkEvent: Command
{
    
    override var names: [String] { ["unlinkEvent"] }
    
    override func run() throws -> [Entity]
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
}

class CommandLinkProcess: Command
{
    
    override var names: [String] { ["linkProcess"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let subprocess: Process = try workspace.entity(at: index)
        let process: Process = try workspace.first()
        process.addToSubProcesses(subprocess)
        return [process]
    }
}

class CommandUnlinkProcess: Command
{
    
    override var names: [String] { ["unlinkProcess"] }
    
    override func run() throws -> [Entity]
    {
        let index = try index()
        let subprocess: Process = try workspace.entity(at: index)
        let process: Process = try workspace.first()
        process.removeFromSubProcesses(subprocess)
        return [process]
    }
}

class CommandBooleanStockFlow: Command
{
    
    override var names: [String] { ["booleanStockFlow"] }
    
    override func run() throws -> [Entity]
    {
        let name = try name()
        
        let stock = EntityType.stock.insertNewEntity(into: database.context, name: name) as! Stock
        stock.current = 0
        stock.target = 1
        stock.max = 1
        stock.valueType = .boolean
        
        // Check as in "check off a box"
        let checkFlow = EntityType.flow.insertNewEntity(into: database.context, name: "Check: " + name) as! Flow
        checkFlow.amount = 1
        checkFlow.duration = 1
        checkFlow.delay = 0
        checkFlow.from = ContextPopulator.sourceStock(context: database.context)
        checkFlow.to = stock
        
        let uncheckFlow = EntityType.flow.insertNewEntity(into: database.context, name: "Uncheck: " + name) as! Flow
        uncheckFlow.amount = 1
        uncheckFlow.duration = 0
        uncheckFlow.delay = 0
        uncheckFlow.from = stock
        uncheckFlow.to = ContextPopulator.sinkStock(context: database.context)
        
        workspace.entities.insert(stock, at: 0)
        workspace.entities.insert(checkFlow, at: 2)
        workspace.entities.insert(uncheckFlow, at: 2)
        
        return [stock, checkFlow, uncheckFlow]
    }
}
