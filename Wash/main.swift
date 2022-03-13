//
//  main.swift
//  Wash
//
//  Created by Joshua Grant on 2/18/22.
//

import Foundation
import CoreData

// The timer that tracks the flows
var timer: Timer?
let database = Database()
var workspace: [Entity] = []

let source = ContextPopulator.fetchOrMakeSourceStock(context: database.context)
let sink = ContextPopulator.fetchOrMakeSinkStock(context: database.context)

// 1. We need to maintain a "context" or "workspace" that contains all of the entities that we're interested in... Like a "recent" or something.
// Whenever we add a new entity - it gets added to the list. The top item is the "automatic" item that's currently selected.
// The rest have a number, 1-10. When we delete an item, it gets removed from the list
// When we select an item, it gets moved into the top spot.
// When we are trying to link items, we use the context numbers to link them...

print("Hello, world!")

var loop = true
var lastCommand = Command(input: "")

while(loop)
{
    guard let input = readLine() else
    {
        print("No input")
        continue
    }
    
    let command = Command(input: input)
    
    switch (command.command, command.arguments)
    {
    case ("add", let arguments):        add(arguments: arguments)
        // Select is for the workspace
    case ("select", let arguments):     select(arguments: arguments)
        // Choose is for `all`
    case ("choose", let arguments):     choose(arguments: arguments, lastCommand: lastCommand)
    case ("pinned", _):                 pinned()
    case ("library", _):                library()
    case ("priority", _):               priority()
    case ("pin", _):                    pin()
    case ("unpin", _):                  unpin()
    case ("save", _):                   save()
    case ("quit", _):                   quit()
    case ("set-name", let arguments):   setName(arguments: arguments)
    case ("hide", _):                   hide()
    case ("unhide", _):                 unhide()
    case ("view", _):                   view()
    case ("delete", _):                 delete()
    case ("all", let arguments):        all(arguments: arguments)
        
        // MARK: - Stocks
    case ("set-type", let arguments):   setType(arguments: arguments)
    case ("set-current", let arguments):    setCurrent(arguments: arguments)
    case ("set-ideal", let arguments):  setIdeal(arguments: arguments)
    case ("set-min", let arguments):    setMin(arguments: arguments)
    case ("set-max", let arguments):    setMax(arguments: arguments)
    case ("set-unit", let arguments):   setUnit(arguments: arguments)
    case ("link-outflow", let arguments):   linkOutflow(arguments: arguments)
    case ("link-inflow", let arguments):    linkInflow(arguments: arguments)
    case ("unlink-outflow", let arguments): unlinkOutflow(arguments: arguments)
    case ("unlink-inflow", let arguments):  unlinkInflow(arguments: arguments)
    case ("link-event", let arguments): linkEvent(arguments: arguments)
    case ("unlink-event", let arguments):   unlinkEvent(arguments: arguments)
        
        // MARK: - Flows
    case ("set-amount", let arguments): setAmount(arguments: arguments)
    case ("set-delay", let arguments):  setDelay(arguments: arguments)
    case ("set-duration", let arguments):   setDuration(arguments: arguments)
    case ("set-requires", let arguments):   setRequiresUserCompletion(arguments: arguments)
    case ("set-from", let arguments):   setFrom(arguments: arguments)
    case ("set-to", let arguments): setTo(arguments: arguments)
    case ("run", _): run()
    default:
        print("Invalid command.")
    }
    
    lastCommand = command
    
    print("Workspace: \(workspace)")
}

func add(arguments: [String])
{
    guard arguments.count > 0 else
    {
        print("Please include an entity type with the add command")
        return
    }
    
    let entityType = arguments[0]
    let name = (arguments.count > 1) ? arguments[1] : nil
    
    switch entityType
    {
    case "stock":
        makeStock(name: name)
    case "flow":
        makeFlow(name: name)
    case "event":
        makeEvent(name: name)
    case "unit":
        makeUnit(name: name)
    default:
        print("Tried to add an invalid entity")
        return
    }
}

func makeStock(name: String?)
{
    let stock = Stock(context: database.context)
    stock.stateMachine = false
    stock.isPinned = false
    stock.createdDate = Date()
    
    let source = Source(context: database.context)
    source.valueType = .number
    source.value = 0
    stock.source = source
    
    let minimum = Source(context: database.context)
    minimum.valueType = .number
    minimum.value = 0
    stock.minimum = minimum
    
    let maximum = Source(context: database.context)
    maximum.valueType = .number
    maximum.value = 100
    stock.maximum = maximum
    
    let ideal = Source(context: database.context)
    ideal.valueType = .number
    ideal.value = 100
    stock.ideal = ideal
    
    if let name = name
    {
        stock.symbolName = Symbol(context: database.context, name: name)
    }
    
    workspace.insert(stock, at: 0)
}

func makeFlow(name: String?)
{
    let flow = Flow(context: database.context)
    
    flow.amount = 1
    flow.delay = 0
    flow.duration = 1
    flow.requiresUserCompletion = false
    
    if let name = name
    {
        flow.symbolName = Symbol(context: database.context, name: name)
    }
    
    workspace.insert(flow, at: 0)
}

func makeEvent(name: String?)
{
    let event = Event(context: database.context)
    
    event.conditionType = .all
    event.isActive = true
    
    if let name = name
    {
        event.symbolName = Symbol(context: database.context, name: name)
    }
    
    workspace.insert(event, at: 0)
}

func makeUnit(name: String?)
{
    let unit = Unit(context: database.context)
    
    unit.isBase = true
    
    if let name = name
    {
        unit.symbolName = Symbol(context: database.context, name: name)
        unit.abbreviation = name
    }
    
    workspace.insert(unit, at: 0)
}

/// Selecting is for focusing a certain item already in the workspace
func select(arguments: [String])
{
    guard let first = arguments.first else
    {
        print("Please include the index to select")
        return
    }
    
    guard let number = Int(first) else
    {
        print("Index was not a number")
        return
    }
    
    guard number < workspace.count else
    {
        print("Index was out of bounds")
        return
    }
    
    let entity = workspace[number]
    workspace.remove(at: number)
    workspace.insert(entity, at: 0)
}

/// Choosing is for adding an item from a list (such as `all stock`)
/// It has to take the last command and then figure out which item to choose...
/// Then, add it to the workspace.
func choose(arguments: [String], lastCommand: Command)
{
    let items: [Any]
    
    switch lastCommand.command {
    case "all":
        items = all(arguments: lastCommand.arguments)
    case "priority":
        items = priority()
    case "pinned":
        items = pinned()
    default:
        print("Last command wasn't valid to choose from")
        return
    }
    
    guard let indexString = arguments.first, let index = Int(indexString) else
    {
        print("Pass an index to the choose command")
        return
    }
    
    guard index < items.count else
    {
        print("The index was greater than the previous command's items count")
        return
    }
    
    guard let item = items[index] as? Named else
    {
        print("The item wasn't `Named`")
        return
    }
    
    workspace.insert(item, at: 0)
}

func pin()
{
    guard let entity = workspace.first else
    {
        print("No entity to pin")
        return
    }
    
    entity.isPinned = true
}

func unpin()
{
    guard let entity = workspace.first else
    {
        print("No entity to unpin")
        return
    }
    
    entity.isPinned = false
}

func hide()
{
    guard let entity = workspace.first else
    {
        print("No entity")
        return
    }
    
    entity.isHidden = true
}

func unhide()
{
    guard let entity = workspace.first else
    {
        print("No entity")
        return
    }
    
    entity.isHidden = false
}

func save()
{
    database.context.quickSave()
}

func quit()
{
    loop = false
}

func setName(arguments: [String])
{
    guard arguments.count > 0 else
    {
        print("No name to set")
        return
    }
    
    let name = arguments.joined(separator: " ")
    
    guard let entity = workspace.first as? SymbolNamed else
    {
        print("No entity")
        return
    }
    
    let symbol = Symbol(context: database.context, name: name)
    entity.symbolName = symbol
}

func view()
{
    guard let entity = workspace.first else
    {
        print("No entity")
        return
    }
    
    if let entity = entity as? Printable
    {
        print(entity.fullDescription)
    }
    else
    {
        print(entity)
    }
}

func delete()
{
    guard let entity = workspace.first else
    {
        print("No entity")
        return
    }
    
    database.context.delete(entity)
}

func library()
{
    for type in EntityType.libraryVisible
    {
        let count = type.count(in: database.context)
        print("\(type.icon.text) \(type.title) (\(count))")
    }
}

func pinned() -> [Pinnable]
{
    let request = Entity.makePinnedObjectsFetchRequest(context: database.context)
    let result = (try? database.context.fetch(request)) ?? []
    let pins = result.compactMap { $0 as? Pinnable }
    print("Pins: \(pins)")
    return pins
}

@discardableResult func priority() -> [Flow]
{
    var suggested: Set<Flow> = []
    let allStocks: [Stock] = Stock.all(context: database.context)
    let unbalancedStocks = allStocks.filter { stock in
        stock.percentIdeal < 1
    }
    
    for stock in unbalancedStocks
    {
        var bestFlow: Flow?
        var bestPercentIdeal: Double = 0
        
        let allFlows = stock.unwrappedInflows + stock.unwrappedOutflows
        
        for flow in allFlows
        {
            let amount: Double
            
            // TODO: Could clean this up a bit
            if stock.unwrappedInflows.contains(where: { $0 == flow })
            {
                amount = -flow.amount
            }
            else if stock.unwrappedOutflows.contains(where: { $0 == flow })
            {
                amount = flow.amount
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

@discardableResult func all(arguments: [String]) -> [NSFetchRequestResult]
{
    guard let first = arguments.first else
    {
        print("No entity type")
        return []
    }
    
    let entityType: EntityType
    
    switch first
    {
    case "stock":
        entityType = .stock
    case "flow":
        entityType = .flow
    case "unit":
        entityType = .unit
    case "event":
        entityType = .event
    default:
        print("Invalid entity type")
        return []
    }
    
    let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
    let result = (try? database.context.fetch(request)) ?? []
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
    
    return result
}

// MARK: - Stocks

/// Sets the `valueTypeRaw` property of the `source` property of the stock
/// Options are:
/// 1. Boolean
/// 2. Infinite
/// 3. Percent
/// 4. Number
/// 5. Date
func setType(arguments: [String])
{
    let validOptionsString = "Valid options are:\nBoolean\nInfinite\nPercent\nNumber\nDate"
    
    guard let type = arguments.first?.lowercased() else {
        print("Please enter a type. \(validOptionsString)")
        return
    }
    
    guard let stock = workspace.first as? Stock else
    {
        print("No entity, or entity isn't a stock.")
        return
    }
    
    switch type
    {
    case "boolean":
        stock.source?.valueType = .boolean
    case "infinite":
        stock.source?.valueType = .infinite
    case "percent":
        stock.source?.valueType = .percent
    case "number":
        stock.source?.valueType = .number
    case "date":
        stock.source?.valueType = .date
    default:
        print("Invalid type. \(validOptionsString)")
    }
}

func getNumberArgumentAndEntity<T: Entity>(arguments: [String]) -> (Double, T)?
{
    guard let argument = arguments.first, let number = Double(argument) else
    {
        print("Please enter a number.")
        return nil
    }
    
    guard let entity = workspace.first as? T else
    {
        print("No entity, or entity isn't a \(T.self)")
        return nil
    }
    
    return (number, entity)
}

func getBooleanArgumentAndEntity<T: Entity>(arguments: [String]) -> (Bool, T)?
{
    guard let argument = arguments.first, let bool = Bool(argument) else
    {
        print("Please enter a boolean")
        return nil
    }
    
    guard let entity = workspace.first as? T else
    {
        print("No entity, or entity isn't a \(T.self)")
        return nil
    }
    
    return (bool, entity)
}

func setCurrent(arguments: [String])
{
    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    stock.current = number
}

func setIdeal(arguments: [String])
{
    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    stock.target = number
}

func setMin(arguments: [String])
{
    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    stock.min = number
}

func setMax(arguments: [String])
{
    guard let (number, stock): (Double, Stock) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    stock.max = number
}

func getEntities<A: Entity, B: Entity>(arguments: [String]) -> (A, B)?
{
    guard workspace.count > 0 else
    {
        print("The workspace is empty")
        return nil
    }
    
    guard let a = workspace.first as? A else
    {
        print("The first entity was not \(A.self)")
        return nil
    }
    
    guard let indexString = arguments.first, let index = Int(indexString) else
    {
        print("Please provide an Int argument for the index. You might be trying to add something when you really want to link it to something in the workspace.")
        return nil
    }
    
    guard index < workspace.count else
    {
        print("The index for the second entity is out of bounds")
        return nil
    }
    
    guard let b = workspace[index] as? B else {
        print("The second entity was not \(B.self)")
        return nil
    }
    
    return (a, b)
}

// TODO: Rather than searching/creating a unit,
// let's use the index of the arguments to find a unit in the workspace
func setUnit(arguments: [String])
{
    guard let (stock, unit): (Stock, Unit) = getEntities(arguments: arguments) else { return }
    stock.unit = unit
}

func linkOutflow(arguments: [String])
{
    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
    stock.addToOutflows(flow)
}

func linkInflow(arguments: [String])
{
    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
    stock.addToInflows(flow)
}

func unlinkOutflow(arguments: [String])
{
    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
    stock.removeFromOutflows(flow)
}

func unlinkInflow(arguments: [String])
{
    guard let (stock, flow): (Stock, Flow) = getEntities(arguments: arguments) else { return }
    stock.removeFromInflows(flow)
}

/// Applies to both flows and stocks
func linkEvent(arguments: [String])
{
}

/// Applies to both flows and stocks
func unlinkEvent(arguments: [String])
{
    
}

// MARK: - Flows

func setAmount(arguments: [String])
{
    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    flow.amount = number
}

func setDelay(arguments: [String])
{
    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    flow.delay = number
}

func setDuration(arguments: [String])
{
    guard let (number, flow): (Double, Flow) = getNumberArgumentAndEntity(arguments: arguments) else { return }
    flow.duration = number
}

func setRequiresUserCompletion(arguments: [String])
{
    guard let (bool, flow): (Bool, Flow) = getBooleanArgumentAndEntity(arguments: arguments) else { return }
    flow.requiresUserCompletion = bool
}

func setFrom(arguments: [String])
{
    guard let (flow, stock): (Flow, Stock) = getEntities(arguments: arguments) else { return }
    flow.from = stock
}

func setTo(arguments: [String])
{
    guard let (flow, stock): (Flow, Stock) = getEntities(arguments: arguments) else { return }
    flow.to = stock
}

func run()
{
    guard let flow = workspace.first as? Flow else
    {
        print("First entity wasn't a flow")
        return
    }
    
    // 1. Wait delay seconds
    // 2. Calculate the amount per second (amount / duration)
    // 3. On a timer, subtract the amount of aps from "from" and add it to "to"
    // 4. If "from" has aps or less, get that amount and add it to "to"
    // 5. If "from" has 0, finish the run
    // 6. If "to" is at the max value, also finish the run
    
    print("Starting. Waiting for \(flow.delay) seconds")
    // Not great.. but does the trick
    sleep(UInt32(flow.delay))
    print("Delay completed.")
    let amount = flow.amount
    runHelper(flow: flow, amount: amount)
}

func runHelper(flow: Flow, amount: Double)
{
    guard let fromSource = flow.from?.source else
    {
        print("No from source")
        return
    }
    
    guard let fromMin = flow.from?.minimum else
    {
        print("No from minimum")
        return
    }
    
    guard let toSource = flow.to?.source else
    {
        print("No to source")
        return
    }
    
    guard let toMax = flow.to?.maximum else
    {
        print("No to maximum")
        return
    }
    
    let aps = flow.amount / flow.duration
    
    var amountToSubtract: Double = min(aps, amount)
    
    if fromSource.value - aps < fromMin.value
    {
        amountToSubtract = fromSource.value
    }
    
    if toSource.value + amountToSubtract > toMax.value
    {
        amountToSubtract = toMax.value - toSource.value
    }
    
    if amountToSubtract <= 0
    {
        print("Done!")
        return
    }
    
    print("Moving resources...")
    print("From: \(fromSource.value), to: \(toSource.value), amount: \(amountToSubtract)")
    
    fromSource.value -= amountToSubtract
    toSource.value += amountToSubtract
    
    print("Sleeping for 1 second")
    sleep(1)
    runHelper(flow: flow, amount: amount - amountToSubtract)
}
