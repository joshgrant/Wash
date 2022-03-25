//
//  main.swift
//  Wash
//
//  Created by Joshua Grant on 2/18/22.
//

import Foundation
import CoreData
import SpriteKit
import Core

let database = Database()

let source = ContextPopulator.fetchOrMakeSourceStock(context: database.context)
let sink = ContextPopulator.fetchOrMakeSinkStock(context: database.context)

var workspace: [Entity] = [source, sink]

print("Hello, world!")

var lastCommand = CommandData(input: "")
var lastResult: [Entity] = []

let inputLoop: (Heartbeat) -> Void = { heartbeat in
    guard let input = readLine() else { return }
    let commandData = CommandData(input: input)
    let command = Command(commandData: commandData, workspace: &workspace, lastResult: lastResult)
    lastResult = command?.run(database: database, workspace: &workspace) ?? []
}

let eventLoop: (Heartbeat) -> Void = { heartbeat in
    evaluateActiveEvents(context: database.context)
    evaluateInactiveEvents(context: database.context)
}

Heartbeat.init(inputLoop: inputLoop, eventLoop: eventLoop)
RunLoop.current.run()


//    let command = Command(input: input)
//
//    if Condition.handleCommand(command: command) {
//        // TODO: Call all of the other functions...
//        continue
//    }
//
//    switch (command.command, command.arguments)
//    {
//    case ("add", let arguments):                add(arguments: arguments, in: database.context)
//        // Select is for the workspace
//    case ("select", let arguments):             select(arguments: arguments)
//        // Choose is for `all`
//    case ("choose", let arguments):             choose(arguments: arguments, lastCommand: lastCommand, in: database.context)
//    case ("pinned", _):                         pinned(context: database.context)
//    case ("unbalanced", _):                     unbalanced(context: database.context)
//    case ("library", _):                        library(context: database.context)
//    case ("priority", _):                       priority(context: database.context)
//    case ("events", _):                         events(context: database.context)
//    case ("pin", _):                            pin()
//    case ("unpin", _):                          unpin()
//    case ("save", _):                           save(context: database.context)
//    case ("quit", _):                           quit()
//    case ("set-name", let arguments):           setName(arguments: arguments, in: database.context)
//    case ("hide", _):                           hide()
//    case ("unhide", _):                         unhide()
//    case ("view", _):                           view()
//    case ("delete", _):                         delete(context: database.context)
//    case ("nuke", _):                           nuke(database: database)
//    case ("clear", _):                          workspace.removeAll()
//    case ("all", let arguments):                all(arguments: arguments, in: database.context)
//
//        // MARK: - Stocks
//    case ("set-type", let arguments):           setType(arguments: arguments)
//    case ("set-current", let arguments):        setCurrent(arguments: arguments)
//    case ("set-ideal", let arguments):          setIdeal(arguments: arguments)
//    case ("set-min", let arguments):            setMin(arguments: arguments)
//    case ("set-max", let arguments):            setMax(arguments: arguments)
//    case ("set-unit", let arguments):           setUnit(arguments: arguments)
//    case ("link-outflow", let arguments):       linkOutflow(arguments: arguments)
//    case ("link-inflow", let arguments):        linkInflow(arguments: arguments)
//    case ("unlink-outflow", let arguments):     unlinkOutflow(arguments: arguments)
//    case ("unlink-inflow", let arguments):      unlinkInflow(arguments: arguments)
//    case ("link-event", let arguments):         linkEvent(arguments: arguments)
//    case ("unlink-event", let arguments):       unlinkEvent(arguments: arguments)
//
//        // MARK: - Flows
//    case ("set-amount", let arguments):         setAmount(arguments: arguments)
//    case ("set-delay", let arguments):          setDelay(arguments: arguments)
//    case ("set-duration", let arguments):       setDuration(arguments: arguments)
//    case ("set-requires", let arguments):       setRequiresUserCompletion(arguments: arguments)
//    case ("set-from", let arguments):           setFrom(arguments: arguments)
//    case ("set-to", let arguments):             setTo(arguments: arguments)
//    case ("run", _): run()
//    case ("add-event", let arguments):          addEvent(arguments: arguments)
//
//        // MARK: - Events
//    case ("set-is-active", let arguments):      setIsActive(arguments: arguments)
//    case ("add-condition", let arguments):      addCondition(arguments: arguments)
//    case ("set-condition-type", let arguments): setConditionType(arguments: arguments)
//    case ("link-flow", let arguments):          linkFlow(arguments: arguments)
//    case ("set-cooldown", let arguments):       setCooldown(arguments: arguments)
//
////        // MARK: Conditions
////    case ("set-comparison", let arguments):
////        guard let condition: Condition = getEntity(from: workspace),
////              let (c, t) = parseTwoStrings(arguments: arguments)
////        else {
////            continue
////        }
////        condition.setComparison(c, type: t)
////    case ("set-left-hand", let arguments):
////        guard let condition: Condition = getEntity(from: workspace) else { continue }
////        condition.leftHand = makeSource(from: arguments, in: database.context)
////    case ("set-right-hand", let arguments):
////        guard let condition: Condition = getEntity(from: workspace) else { continue }
////        condition.rightHand = makeSource(from: arguments, in: database.context)
//    default:
//        print("Invalid command.")
//    }
//
//    lastCommand = command
//
//    evaluateActiveEvents(context: database.context)
//    evaluateInactiveEvents(context: database.context)
//
//    print("Workspace: \(workspace)")
//}

func evaluateInactiveEvents(context: Context)
{
    let request: NSFetchRequest<Event> = Event.fetchRequest()
    request.predicate = NSPredicate(format: "isActive == false")
    let events = (try? context.fetch(request)) ?? []
    for event in events
    {
        guard let lastTrigger = event.lastTrigger else { continue }
        let cooldownDate = Date(timeInterval: event.cooldownSeconds, since: lastTrigger)
        if cooldownDate.timeIntervalSinceNow <= 0
        {
            event.isActive = true
        }
    }
}

// TODO: Questions - an event may be active for a long time.
/// Options: 1. Kill switch. Once an event is run, it gets set to "isActive: false". Add a "cooldown" value that determines how long until the event is active again
// TODO: Automatically add a condition and stock upon event creation (isActive) ?? and
func evaluateActiveEvents(context: Context)
{
    let events = Event.activeAndSatisfiedEvents(context: context)
    for event in events
    {
        for flow in event.unwrappedFlows
        {
            if !flow.requiresUserCompletion
            {
                flow.run()
            }
            else
            {
                // TODO: FIX THIS
                // Add the flow to the ones requiring user completion???
            }
        }
        event.lastTrigger = Date()
        event.isActive = false
    }
}

/// Returns events that are active and satisfied
/// AKA Events that should trigger
//func activeAndSatisfiedEvents(context: Context) -> [Event]
//{
//    let request: NSFetchRequest<Event> = Event.fetchRequest()
//    let events = (try? context.fetch(request)) ?? []
//    
//    var trueEvents: [Event] = []
//    
//    for event in events
//    {
//        if event.shouldTrigger
//        {
//            trueEvents.append(event)
//        }
//    }
//    
//    return trueEvents
//}

//func setCooldown(arguments: [String])
//{
//    guard let (cooldown, event): (Double, Event) = getNumberArgumentAndEntity(arguments: arguments) else
//    {
//        print("Failed to get a number and event")
//        return
//    }
//    event.cooldownSeconds = cooldown
//}
//
//func events(context: Context)
//{
//    let events = activeAndSatisfiedEvents(context: context)
//    for event in events
//    {
//        print(event)
//    }
//}

//func addEvent(arguments: [String])
//{
//    if let (flow, event): (Flow, Event) = getEntities(arguments: arguments) {
//        flow.addToEvents(event)
//        return
//    }
//
//    print("Unhandled entity. Go to `addEvent` to update")
//}
//
//func linkFlow(arguments: [String])
//{
//    if let (event, flow): (Event, Flow) = getEntities(arguments: arguments) {
//        event.addToFlows(flow)
//        return
//    }
//
//    print("Unhandled entity. Go to `linkFlow` to update")
//}
//
//func nuke(database: Database)
//{
//    database.clear()
//}

//func add(arguments: [String], in context: Context)
//{
//    guard arguments.count > 0 else
//    {
//        print("Please include an entity type with the add command")
//        return
//    }
//
//    let entityType = arguments[0]
//    let name = (arguments.count > 1) ? arguments[1] : nil
//
//    switch entityType
//    {
//    case "stock":
//        makeStock(name: name, in: context)
//    case "flow":
//        makeFlow(name: name, in: context)
//    case "event":
//        makeEvent(name: name, in: context)
//    case "unit":
//        Unit.make(name: name, in: context, workspace: &workspace)
//    case "condition":
//        Condition.make(name: name, in: context, workspace: &workspace)
//    default:
//        print("Tried to add an invalid entity")
//        return
//    }
//}

/// Selecting is for focusing a certain item already in the workspace
//func select(arguments: [String])
//{
//    guard let first = arguments.first else
//    {
//        print("Please include the index to select")
//        return
//    }
//
//    guard let number = Int(first) else
//    {
//        print("Index was not a number")
//        return
//    }
//
//    guard number < workspace.count else
//    {
//        print("Index was out of bounds")
//        return
//    }
//
//    let entity = workspace[number]
//    workspace.remove(at: number)
//    workspace.insert(entity, at: 0)
//}

/// Choosing is for adding an item from a list (such as `all stock`)
/// It has to take the last command and then figure out which item to choose...
/// Then, add it to the workspace.
//func choose(arguments: [String], lastCommand: CommandData, in context: Context)
//{
//    let items: [Any]
//
//    switch lastCommand.command {
//    case "all":
//        items = all(arguments: lastCommand.arguments, in: context)
//    case "priority":
//        items = priority(context: context)
//    case "pinned":
//        items = pinned(context: context)
//    default:
//        print("Last command wasn't valid to choose from")
//        return
//    }
//
//    guard let indexString = arguments.first, let index = Int(indexString) else
//    {
//        print("Pass an index to the choose command")
//        return
//    }
//
//    guard index < items.count else
//    {
//        print("The index was greater than the previous command's items count")
//        return
//    }
//
//    guard let item = items[index] as? Named else
//    {
//        print("The item wasn't `Named`")
//        return
//    }
//
//    workspace.insert(item, at: 0)
//}

//func pin()
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity to pin")
//        return
//    }
//
//    entity.isPinned = true
//}
//
//func unpin()
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity to unpin")
//        return
//    }
//
//    entity.isPinned = false
//}

//func hide()
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity")
//        return
//    }
//
//    entity.isHidden = true
//}
//
//func unhide()
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity")
//        return
//    }
//
//    entity.isHidden = false
//}
//
//func save(context: Context)
//{
//    context.quickSave()
//}
//
//func quit()
//{
////    loop = false
//}

//func setName(arguments: [String], in context: Context)
//{
//    guard arguments.count > 0 else
//    {
//        print("No name to set")
//        return
//    }
//
//    let name = arguments.joined(separator: " ")
//
//    guard let entity = workspace.first as? SymbolNamed else
//    {
//        print("No entity")
//        return
//    }
//
//    let symbol = Symbol(context: context, name: name)
//    entity.symbolName = symbol
//}
//
//func view()
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity")
//        return
//    }
//
//    if let entity = entity as? Printable
//    {
//        print(entity.fullDescription)
//    }
//    else
//    {
//        print(entity)
//    }
//}
//
//func delete(context: Context)
//{
//    guard let entity = workspace.first else
//    {
//        print("No entity")
//        return
//    }
//
//    context.delete(entity)
//}

//func library(context: Context)
//{
//    for type in EntityType.libraryVisible
//    {
//        let count = type.count(in: context)
//        print("\(type.icon.text) \(type.title) (\(count))")
//    }
//}

//@discardableResult func pinned(context: Context) -> [Pinnable]
//{
//    let request = Entity.makePinnedObjectsFetchRequest(context: context)
//    let result = (try? context.fetch(request)) ?? []
//    let pins = result.compactMap { $0 as? Pinnable }
//    print("Pins: \(pins)")
//    return pins
//}

//@discardableResult func unbalanced(context: Context) -> [Stock]
//{
//    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
//    let result = (try? context.fetch(request)) ?? []
//    let unbalanced = result.filter { $0.percentIdeal < Stock.thresholdPercent }
//    print("Unbalanced: \(unbalanced)")
//    return unbalanced
//}

//@discardableResult func priority(context: Context) -> [Flow]
//{
//    var suggested: Set<Flow> = []
//    let allStocks: [Stock] = Stock.all(context: context)
//    let unbalancedStocks = allStocks.filter { stock in
//        stock.percentIdeal < 1
//    }
//
//    for stock in unbalancedStocks
//    {
//        var bestFlow: Flow?
//        var bestPercentIdeal: Double = 0
//
//        let allFlows = stock.unwrappedInflows + stock.unwrappedOutflows
//
//        for flow in allFlows
//        {
//            let amount: Double
//
//            // TODO: Could clean this up a bit
//            if stock.unwrappedInflows.contains(where: { $0 == flow })
//            {
//                amount = -flow.amount
//            }
//            else if stock.unwrappedOutflows.contains(where: { $0 == flow })
//            {
//                amount = flow.amount
//            }
//            else
//            {
//                print("Something's wrong: flow wasn't part of inflows or outflows")
//                fatalError()
//            }
//
//            let projectedCurrent = min(stock.max, stock.current + amount)
//            let projectedPercentIdeal = Double.percentDelta(
//                a: projectedCurrent,
//                b: stock.target,
//                minimum: stock.min,
//                maximum: stock.max)
//            if projectedPercentIdeal > bestPercentIdeal
//            {
//                bestFlow = flow
//                bestPercentIdeal = projectedPercentIdeal
//            }
//        }
//
//        if let flow = bestFlow
//        {
//            suggested.insert(flow)
//        }
//    }
//
//    print("Priority: \(suggested)")
//    return Array(suggested)
//}

//@discardableResult func all(arguments: [String], in context: Context) -> [NSFetchRequestResult]
//{
//    guard let first = arguments.first else
//    {
//        print("No entity type")
//        return []
//    }
//
//    let entityType: EntityType
//
//    switch first
//    {
//    case "stock":
//        entityType = .stock
//    case "flow":
//        entityType = .flow
//    case "unit":
//        entityType = .unit
//    case "event":
//        entityType = .event
//    case "condition":
//        entityType = .condition
//    default:
//        print("Invalid entity type")
//        return []
//    }
//
//    let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
//    request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
//    let result = (try? context.fetch(request)) ?? []
//    guard result.count > 0 else {
//        print("No results")
//        return []
//    }
//
//    for item in result.enumerated()
//    {
//        if let entity = item.element as? Named
//        {
//            let icon = entityType.icon.text
//            print("\(item.offset): \(icon) \(entity.title)")
//        }
//    }
//
//    return result
//}

// MARK: - Stocks

//func setCurrent(arguments: [String])
//{
//    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    stock.current = number
//}
//
//func setIdeal(arguments: [String])
//{
//    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    stock.target = number
//}
//
//func setMin(arguments: [String])
//{
//    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    stock.min = number
//}
//
//func setMax(arguments: [String])
//{
//    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    stock.max = number
//}
//
//// TODO: Rather than searching/creating a unit,
//// let's use the index of the arguments to find a unit in the workspace
//func setUnit(arguments: [String])
//{
//    guard let (stock, unit): (Stock, Unit) = getEntities(arguments: arguments) else { return }
//    stock.unit = unit
//}
//
//func linkOutflow(arguments: [String])
//{
//    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
//    stock.addToOutflows(flow)
//}
//
//func linkInflow(arguments: [String])
//{
//    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
//    stock.addToInflows(flow)
//}
//
//func unlinkOutflow(arguments: [String])
//{
//    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
//    stock.removeFromOutflows(flow)
//}
//
//func unlinkInflow(arguments: [String])
//{
//    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
//    stock.removeFromInflows(flow)
//}

/// Applies to both flows and stocks
//func linkEvent(arguments: [String])
//{
//}
//
///// Applies to both flows and stocks
//func unlinkEvent(arguments: [String])
//{
//
//}

// MARK: - Flows

//func setAmount(arguments: [String])
//{
//    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    flow.amount = number
//}
//
//func setDelay(arguments: [String])
//{
//    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    flow.delay = number
//}
//
//func setDuration(arguments: [String])
//{
//    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
//    flow.duration = number
//}
//
//func setRequiresUserCompletion(arguments: [String])
//{
//    guard let (bool, flow): (Bool, Flow) = getBooleanArgumentAndEntity(arguments: arguments) else { return }
//    flow.requiresUserCompletion = bool
//}
//
//func setFrom(arguments: [String])
//{
//    guard let (flow, stock): (Flow, Stock) = getEntities(arguments: arguments) else { return }
//    flow.from = stock
//}
//
//func setTo(arguments: [String])
//{
//    guard let (flow, stock): (Flow, Stock) = getEntities(arguments: arguments) else { return }
//    flow.to = stock
//}

//func run(flow: Flow? = nil)
//{
//    guard let flow = flow ?? (workspace.first as? Flow) else
//    {
//        print("First entity wasn't a flow")
//        return
//    }
//    
//    // 1. Wait delay seconds
//    // 2. Calculate the amount per second (amount / duration)
//    // 3. On a timer, subtract the amount of aps from "from" and add it to "to"
//    // 4. If "from" has aps or less, get that amount and add it to "to"
//    // 5. If "from" has 0, finish the run
//    // 6. If "to" is at the max value, also finish the run
//    
//    print("Starting. Waiting for \(flow.delay) seconds")
//    // Not great.. but does the trick
//    sleep(UInt32(flow.delay))
//    print("Delay completed.")
//    let amount = flow.amount
//    runHelper(flow: flow, amount: amount)
//}
//
//func runHelper(flow: Flow, amount: Double)
//{
//    guard let fromSource = flow.from?.source else
//    {
//        print("No from source")
//        return
//    }
//    
//    guard let fromMin = flow.from?.minimum else
//    {
//        print("No from minimum")
//        return
//    }
//    
//    guard let toSource = flow.to?.source else
//    {
//        print("No to source")
//        return
//    }
//    
//    guard let toMax = flow.to?.maximum else
//    {
//        print("No to maximum")
//        return
//    }
//    
//    let aps = flow.amount / flow.duration
//    
//    var amountToSubtract: Double = min(aps, amount)
//    
//    if fromSource.value - aps < fromMin.value
//    {
//        amountToSubtract = fromSource.value
//    }
//    
//    if toSource.value + amountToSubtract > toMax.value
//    {
//        amountToSubtract = toMax.value - toSource.value
//    }
//    
//    if amountToSubtract <= 0
//    {
//        print("Done!")
//        return
//    }
//    
//    print("Moving resources...")
//    print("From: \(fromSource.value), to: \(toSource.value), amount: \(amountToSubtract)")
//    
//    fromSource.value -= amountToSubtract
//    toSource.value += amountToSubtract
//    
//    print("Sleeping for 1 second")
//    sleep(1)
//    runHelper(flow: flow, amount: amount - amountToSubtract)
//}

//func setIsActive(arguments: [String])
//{
//    guard let (bool, event): (Bool, Event) = getBooleanArgumentAndEntity(arguments: arguments) else
//    {
//        print("Couldn't get an event and a boolean to set is active")
//        return
//    }
//
//    event.isActive = bool
//}
//
//func addCondition(arguments: [String])
//{
//    guard let (event, condition): (Event, Condition) = getEntities(arguments: arguments) else
//    {
//        print("Couldn't find an event, condition")
//        return
//    }
//
//    event.addToConditions(condition)
//}

/// Sets `all` or `any` on the condition
func setConditionType(arguments: [String])
{
    guard let string = arguments.first else
    {
        print("Please provide a condition type: `all` or `any`")
        return
    }
    
    guard let type = ConditionType(string) else
    {
        print("Invalid condition type")
        return
    }
    
    guard let event = workspace.first as? Event else
    {
        print("The first entity in the workspace was not an event")
        return
    }
    
    event.conditionType = type
}

func setRightHand(arguments: [String], in context: Context)
{
    guard let condition = workspace.first as? Condition else
    {
        print("Failed to get a condition from the workspace")
        return
    }
    condition.rightHand = makeSource(from: arguments, in: context)
}

// MARK: - Utility

func makeSource(from arguments: [String], in context: Context) -> Source
{
    if let argument = parseWorkspaceSource(from: arguments)
    {
        return argument
    }
    if let dateSource = parseDateSource(from: arguments, in: context)
    {
        return dateSource
    }
    else if let number: Double = parseType(from: arguments)
    {
        return makeSource(with: number, type: .number, in: context)
    }
    else if let bool: Bool = parseType(from: arguments)
    {
        return makeSource(with: bool, in: context)
    }
    // TODO: Parse percent, infinity
    
    fatalError()
}

func parseWorkspaceSource(from arguments: [String]) -> Source?
{
    guard let first = arguments.first else
    {
        print("No arguments, no source")
        return nil
    }
    
    if first.first == "$"
    {
        if let number = try? Int(first, strategy: IntegerParseStrategy(format: .currency(code: "usd")))
        {
            guard workspace.count > number else
            {
                print("Magic workspace argument was too large. Out-of-bounds")
                return nil
            }
            
            return getSource(from: workspace[number])
        }
        
        return nil
    }
    else
    {
        return nil
    }
}


func getSource(from entity: Entity) -> Source?
{
    switch entity
    {
    case (let s as Stock):
        return s.source
    default:
        return nil
    }
}

func makeSource(with value: Double, type: SourceValueType, in context: Context) -> Source
{
    let source = Source(context: context)
    source.value = value
    source.valueType = type
    return source
}

func makeSource(with bool: Bool, in context: Context) -> Source
{
    let source = Source(context: context)
    source.booleanValue = bool
    source.valueType = .boolean
    return source
}

func parseDateSource(from arguments: [String], in context: Context) -> Source?
{
    guard arguments.count > 0 else
    {
        print("Couldn't parse date; arguments was empty")
        return nil
    }
    
    let argument = arguments.joined(separator: " ")
    
    if argument.localizedLowercase == "now"
    {
        let source = Source(context: context)
        source.valueType = .date
        source.value = -1 // -1 is how we show "now"
        return source
    }
    else if let date = try? Date(argument, strategy: .dateTime.month().day().year())
    {
        let source = Source(context: context)
        source.valueType = .date
        source.value = date.timeIntervalSinceReferenceDate
        return source
    }
    else
    {
        return nil
    }
}

//func getEntity<T: Entity>(from workspace: [Entity]) -> T?
//{
//    guard let entity = workspace.first as? T else
//    {
//        print("Couldn't find an entity of type \(T.self)")
//        return nil
//    }
//
//    return entity
//}

/// Option A is the first entity in the workspace. Option B is from the arguments
//func getEntities<A: Entity, B: Entity>(arguments: [String]) -> (A, B)?
//{
//    guard workspace.count > 0 else
//    {
//        print("The workspace is empty")
//        return nil
//    }
//
//    guard let a = workspace.first as? A else
//    {
//        print("The first entity was not \(A.self)")
//        return nil
//    }
//
//    guard let indexString = arguments.first, let index = Int(indexString) else
//    {
//        print("Please provide an Int argument for the index. You might be trying to add something when you really want to link it to something in the workspace.")
//        return nil
//    }
//
//    guard index < workspace.count else
//    {
//        print("The index for the second entity is out of bounds")
//        return nil
//    }
//
//    guard let b = workspace[index] as? B else {
//        print("The second entity was not \(B.self)")
//        return nil
//    }
//
//    return (a, b)
//}

//func getNumberArgumentAndEntity<T: Entity>(arguments: [String]) -> (Double, T)?
//{
//    guard let argument = arguments.first, let number = Double(argument) else
//    {
//        print("Please enter a number.")
//        return nil
//    }
//    
//    guard let entity = workspace.first as? T else
//    {
//        print("No entity, or entity isn't a \(T.self)")
//        return nil
//    }
//    
//    return (number, entity)
//}
//
//func getBooleanArgumentAndEntity<T: Entity>(arguments: [String]) -> (Bool, T)?
//{
//    guard let argument = arguments.first, let bool = Bool(argument) else
//    {
//        print("Please enter a boolean")
//        return nil
//    }
//    
//    guard let entity = workspace.first as? T else
//    {
//        print("No entity, or entity isn't a \(T.self)")
//        return nil
//    }
//    
//    return (bool, entity)
//}
