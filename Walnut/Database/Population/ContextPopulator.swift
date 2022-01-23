//
//  ContextPopulator.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import CoreData
import Fakery

class ContextPopulator
{
    static let faker = Faker()
    
    static func populate(context: Context)
    {
        fetchOrMakeSourceStock(context: context)
        fetchOrMakeSinkStock(context: context)
        
        guard stockCount(context: context) < 12 else { return }
        
        for _ in 0 ..< .random(in: 3 ... 5)
        {
            makeRandomStock(context: context)
        }

        for _ in 0 ..< .random(in: 3 ... 5)
        {
            makeRandomFlow(context: context)
        }

        for _ in 0 ..< .random(in: 0 ... 2)
        {
            makeRandomNote(context: context)
        }

        for _ in 0 ..< .random(in: 1 ... 4)
        {
            makeRandomTask(context: context)
        }
        
        for _ in 0 ..< .random(in: 0 ... 10)
        {
            makeRandomConversion(context: context)
        }
        
        context.quickSave()
    }
    
    // MARK: - Source & Sink
    
    static var sinkId = UUID(uuidString: "5AB9D2AA-3A20-4771-B923-71BDD93E53E3")!
    static var sourceId = UUID(uuidString: "8F710523-FD11-406C-AA97-C71B625C031B")!
    
    @discardableResult private static func fetchOrMakeSourceStock(context: Context) -> Stock
    {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Stock.uniqueID), sourceId as CVarArg)
        
        do
        {
            guard let stock = try context.fetch(fetchRequest).first else
            {
                return makeSourceStock(context: context)
            }
            
            return stock
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    private static func makeSourceStock(context: Context) -> Stock
    {
        let stock = Stock(context: context)
        stock.uniqueID = sourceId
        
        let source = Source(context: context)
        source.valueType = .infinite
        source.value = .infinity
        
        stock.source = source
        
        stock.minimum = Source(context: context)
        stock.minimum?.value = -.infinity
        
        stock.maximum = Source(context: context)
        stock.maximum?.value = .infinity
        
        stock.ideal = Source(context: context)
        stock.ideal?.value = -.infinity
        
        let symbol = Symbol(context: context)
        symbol.name = "Source".localized
        
        stock.symbolName = symbol
        stock.isPinned = true
        
        return stock
    }
    
    @discardableResult private static func fetchOrMakeSinkStock(context: Context) -> Stock
    {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Stock.uniqueID), sinkId as CVarArg)
        
        do
        {
            guard let stock = try context.fetch(fetchRequest).first else
            {
                return makeSinkStock(context: context)
            }
            
            return stock
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    private static func makeSinkStock(context: Context) -> Stock
    {
        let sink = Stock(context: context)
        sink.uniqueID = sinkId
        
        let source = Source(context: context)
        source.valueType = .infinite
        source.value = -.infinity
        
        sink.source = source
        
        sink.minimum = Source(context: context)
        sink.minimum?.value = -.infinity
        
        sink.maximum = Source(context: context)
        sink.maximum?.value = .infinity
        
        sink.ideal = Source(context: context)
        sink.ideal?.value = .infinity
        
        let sinkSymbol = Symbol(context: context)
        sinkSymbol.name = "Sink".localized
        
        sink.symbolName = sinkSymbol
        sink.isPinned = true
        
        return sink
    }
    
    // MARK: - Stocks
    
    private static func stockCount(context: Context) -> Int
    {
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        return (try? context.fetch(request).count) ?? 0
    }
    
    private static func getRandomStocks(context: Context, max: Int = 3) -> [Stock]
    {
        let stockRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do
        {
            let stocks = try context.fetch(stockRequest)
            
            guard stocks.count > 0 else { return [] }
            
            // Get random elements
            
            var output: [Stock] = []

            for _ in 0 ..< max
            {
                output.append(stocks.randomElement()!)
            }
            
            return output
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }

    @discardableResult private static func makeRandomStock(context: Context) -> Stock
    {
        let stock = Stock(context: context)
        stock.stateMachine = .random()
        
        stock.source = makeRandomSource(context: context)
        
        // Smallest to largest
        let values: [Double] = [
            .veryRandom(),
            .veryRandom(),
            .veryRandom(),
            .veryRandom()].sorted(by: <)
        
        stock.minimum = Source(context: context)
        stock.minimum?.value = values[0]
        
        if .random()
        {
            stock.source = Source(context: context)
            stock.source?.value = values[1]
            
            stock.ideal = Source(context: context)
            stock.ideal?.value = values[2]
        }
        else
        {
            stock.source = Source(context: context)
            stock.source?.value = values[2]
            
            stock.ideal = Source(context: context)
            stock.ideal?.value = values[1]
        }
        
        for _ in 0 ..< .random(in: 0 ... 5)
        {
            let note = makeRandomNote(context: context)
            stock.addToNotes(note)
        }
        
        stock.maximum = Source(context: context)
        stock.maximum?.value = values[3]
        
        stock.symbolName = makeRandomSymbol(context: context)
        stock.isPinned = .random()
        stock.createdDate = Date()
        return stock
    }
    
    private static func minSource(_ a: Source, _ b: Source, _ rest: Source...) -> Source
    {
        var source: Source = a
        var minValue: Double = a.value
        let rest = rest + [b]
        
        for s in rest
        {
            if s.value < minValue
            {
                source = s
                minValue = s.value
            }
        }
        
        return source
    }
    
    private static func maxSource(_ a: Source, _ b: Source, _ rest: Source...) -> Source
    {
        var source: Source = a
        var maxValue: Double = a.value
        let rest = rest + [b]
        
        for s in rest
        {
            if s.value > maxValue
            {
                source = s
                maxValue = s.value
            }
        }
        
        return source
    }
    
    // MARK: - Source
    
    private static func makeRandomSource(context: Context) -> Source
    {
        let source = Source(context: context)
        source.valueType = .random()
        source.value = .random(in: -10e10 ..< 10e10)
        return source
    }
    
    // MARK: - Symbol
    
    private static func makeRandomSymbol(context: Context) -> Symbol
    {
        let symbol = Symbol(context: context)
        symbol.name = faker.lorem.word().capitalized
        return symbol
    }
    
    // MARK: - Condition

    private static func makeRandomCondition(context: Context) -> Condition
    {
        let condition = Condition(context: context)
        
        switch ComparisonType.random()
        {
        case .boolean:
            condition.booleanComparisonType = .random()
            
            let symbol = Symbol(context: context)
            symbol.name = "Boolean condition"
            condition.symbolName = symbol
            
            let leftHand = Source(context: context)
            leftHand.valueType = .boolean
            leftHand.booleanValue = .random()
            
            let rightHand = Source(context: context)
            rightHand.valueType = .boolean
            rightHand.booleanValue = .random()
            
            condition.leftHand = leftHand
            condition.rightHand = rightHand
            
        case .number:
            condition.numberComparisonType = .random()
            
            let symbol = Symbol(context: context)
            symbol.name = "Number condition"
            condition.symbolName = symbol
            
            let leftHand = Source(context: context)
            leftHand.valueType = .number
            leftHand.numberValue = .random(in: -10e10 ... 10e10)
            
            let rightHand = Source(context: context)
            rightHand.valueType = .number
            rightHand.numberValue = .random(in: -10e10 ... 10e10)
            
            condition.leftHand = leftHand
            condition.rightHand = rightHand
            
        case .date:
            condition.dateComparisonType = .random()
            
            let symbol = Symbol(context: context)
            symbol.name = "Date condition"
            condition.symbolName = symbol
            
            let leftHand = Source(context: context)
            leftHand.valueType = .date
            leftHand.dateValue = Date(timeIntervalSinceReferenceDate: .random(in: -10e10 ... 10e10))
            
            let rightHand = Source(context: context)
            rightHand.valueType = .date
            rightHand.dateValue = Date(timeIntervalSinceReferenceDate: .random(in: -10e10 ... 10e10))
            
            condition.leftHand = leftHand
            condition.rightHand = rightHand
        }
        
        return condition
    }
    
    // MARK: - Flow
    
    @discardableResult private static func makeRandomFlow(context: Context) -> Flow
    {
        let flow = Flow(context: context)
        flow.amount = .random(in: 0 ... 1000) // Flow amount is always positive, otherwise the flow from/to would be reversed
        flow.delay = .random(in: 0 ... 5)
        flow.duration = .random(in: 0 ... 1000)
        flow.requiresUserCompletion = .random()
        
        for _ in 0 ..< .random(in: 0 ... 3)
        {
            let event = makeRandomEvent(context: context)
            flow.addToEvents(event)
        }
        
        for _ in 0 ..< .random(in: 0 ... 10)
        {
            let history = makeRandomHistory(context: context)
            flow.addToHistory(history)
        }
        
        for _ in 0 ..< .random(in: 0 ... 3)
        {
            let note = makeRandomNote(context: context)
            flow.addToNotes(note)
        }
        
        // TODO: A stock inflow must have itself as the destination
        // A stock outflow must have itself as the source...
        
        let (from, to) = getFromToStocks(context: context)
        flow.from = from
        flow.to = to
        
        from.addToOutflows(flow)
        to.addToInflows(flow)
        
        flow.symbolName = makeRandomSymbol(context: context)
        
        return flow
    }
    
    /// Conditions:
    /// 1. Sink can never be a "from" stock
    /// 2. Source can never be a "to" stock
    /// 3. A stock can not be both "from" and "to"
    static func getFromToStocks(context: Context) -> (from: Stock, to: Stock)
    {
        var a: Stock?
        var b: Stock?
        
        // Not super efficient...
        while (a == nil || b == nil) {
            if a == nil {
                a = getRandomStocks(context: context, max: 1).first
            }
            
            if b == nil {
                b = getRandomStocks(context: context, max: 1).first
            }
            
            if a?.uniqueID == sourceId && b?.uniqueID == sinkId { a = nil; b = nil; continue }
            
            if a?.uniqueID == sinkId { a = nil }
            if b?.uniqueID == sourceId { b = nil }
            
            if a == b { b = nil }
        }
        
        guard let a = a, let b = b else { fatalError() }
        
        return (a, b)
    }
    
    // MARK: - Events
    
    @discardableResult private static func makeRandomEvent(context: Context) -> Event
    {
        let event = Event(context: context)
        event.conditionType = .allCases.randomElement()!
        event.isActive = .random()
        event.symbolName = makeRandomSymbol(context: context)
        event.history = NSSet(array: makeRandomHistories(context: context))
        
        if .random()
        {
            for _ in 0 ..< .random(in: 0 ... 3)
            {
                let note = makeRandomNote(context: context)
                event.addToNotes(note)
            }
        }
        
        if .random()
        {
            for _ in 0 ..< .random(in: 0 ... 3)
            {
                let condition = makeRandomCondition(context: context)
                event.addToConditions(condition)
            }
        }
        
        return event
    }
    
    // MARK: - Blocks
    
    @discardableResult private static func makeRandomBlock(context: Context) -> Block
    {
        let block = Block(context: context)
        
        block.backgroundColor = makeRandomColor(context: context)
        block.mainColor = makeRandomColor(context: context)
        block.textColor = makeRandomColor(context: context)
        block.tintColor = makeRandomColor(context: context)
        
        block.imageURL = URL(string: faker.internet.image())
        block.url = URL(string: faker.internet.url())
        block.imageCaption = faker.lorem.sentence()
        block.text = faker.lorem.sentence()
        block.textSizeType = .random()
        block.textStyleType = .random()
        
        return block
    }
    
    // MARK: - Unit
    
    @discardableResult private static func makeRandomUnit(context: Context) -> Unit
    {
        let unit = Unit(context: context)
        unit.isBase = .random()
        unit.abbreviation = faker.lorem.characters(amount: 3)
        unit.symbolName = makeRandomSymbol(context: context)
        
        if .random()
        {
            for _ in 0 ..< .random(in: 0 ... 3)
            {
                let derivedUnit = makeRandomUnit(context: context)
                unit.addToChildren(derivedUnit)
            }
        }
        
        return unit
    }
    
    // MARK: - Conversion
    
    @discardableResult private static func makeRandomConversion(context: Context) -> Conversion
    {
        let conversion = Conversion(context: context)
        conversion.isReversible = .random()
        conversion.leftValue = .random(in: -10e10 ... 10e10)
        conversion.rightValue = .random(in: -10e10 ... 10e10)
        conversion.leftUnit = makeRandomUnit(context: context)
        conversion.rightUnit = makeRandomUnit(context: context)
        conversion.symbolName = makeRandomSymbol(context: context)
        return conversion
    }
    
    // MARK: - Color
    
    @discardableResult private static func makeRandomColor(context: Context) -> Color
    {
        let color = Color(context: context)
        
        color.brightness = .random(in: 0 ... 1)
        color.hue = .random(in: 0 ... 1)
        color.saturation = .random(in: 0 ... 1)
        
        return color
    }
    
    // MARK: - Notes
    
    @discardableResult private static func makeRandomNote(context: Context) -> Note
    {
        // first and second line are transient (i.e generated from the blocks, right?)
        
        let note = Note(context: context)
        
        // Add blocks
        for _ in 1 ..< .random(in: 1 ... 10)
        {
            note.addToBlocks(makeRandomBlock(context: context))
        }
        
        // Add subnotes
        if .random()
        {
            for _ in 0 ..< .random(in: 0 ... 3)
            {
                note.addToSubnotes(makeRandomNote(context: context))
            }
        }
        
        // Find related notes
        if .random()
        {
            let relatedNotes = NSSet(array: getRandomNote(context: context, limit: .random(in: 0 ... 5)))
            note.addToRelatedNotes(relatedNotes)
        }
        
        return note
    }
    
    private static func getRandomNote(context: Context, limit: Int = 3) -> [Note]
    {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.fetchLimit = limit
        
        do
        {
            let notes = try context.fetch(request)
            guard notes.count > 0 else { return []}
            
            var output: [Note] = []
            
            for _ in 0 ..< limit
            {
                output.append(notes.randomElement()!)
            }
            
            return output
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    // MARK: - History
    
    @discardableResult private static func makeRandomHistory(context: Context) -> History
    {
        let history = History(context: context)
        
        let endRange = Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate
        let interval = TimeInterval.random(in: 0 ..< endRange)
        
        history.date = Date(timeIntervalSinceReferenceDate: interval)
        history.eventType = .random()
        history.source = makeRandomSource(context: context) // TODO: Could be better?
        
        return history
    }
    
    private static func makeRandomHistories(context: Context, limit: Int = 10) -> [History]
    {
        var histories: [History] = []
        
        for _ in 0 ..< .random(in: 0 ... limit)
        {
            histories.append(makeRandomHistory(context: context))
        }
        
        return histories
    }
    
    // MARK: - Tasks
    
    @discardableResult private static func makeRandomTask(context: Context, endCount: Int = 3) -> Task
    {
        let task = Task(context: context)
        
        task.completionOrderType = .random()
        task.completionType = .random()
        task.sortOrder = .random(in: 0 ..< 100) // Where this task belongs
        task.secondaryText = faker.lorem.sentence()
        task.text = faker.lorem.sentence()
        
        let requiredStocks = NSSet(array: getRandomStocks(context: context))
        let producedStocks = NSSet(array: getRandomStocks(context: context))
        
        task.addToRequiredStocks(requiredStocks)
        task.addToProducedStocks(producedStocks)
        
        guard endCount > 0 else { return task }
        
        if .random()
        {
            for _ in 0 ..< 5
            {
                let child = makeRandomTask(context: context, endCount: endCount - 1)
                task.addToSubtasks(child)
            }
        }
        
        return task
    }
}
