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
        
        makeRandomStocks(context: context)
        
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
        source.value = 1
        
        stock.source = source
        
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
        source.value = -1
        
        sink.source = source
        
        let sinkSymbol = Symbol(context: context)
        sinkSymbol.name = "Sink".localized
        
        sink.symbolName = sinkSymbol
        sink.isPinned = true
        
        return sink
    }
    
    // MARK: - Stocks
    
    private static func getRandomStocks(context: Context, max: Int = 3) -> [Stock]
    {
        let stockRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        stockRequest.fetchLimit = max
        
        do
        {
            return try context.fetch(stockRequest)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    /// Limit is the maximum of stocks that can exist in the database
    private static func makeRandomStocks(context: Context, limit: Int = 50)
    {
        let stockCountRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do
        {
            let fetchedStocks = try context.fetch(stockCountRequest)
            guard fetchedStocks.count <= limit else { return }
            for _ in 0 ..< Int.random(in: 1 ... 10)
            {
                makeRandomStock(context: context)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
        }
    }
    
    @discardableResult private static func makeRandomStock(context: Context) -> Stock
    {
        let stock = Stock(context: context)
        stock.stateMachine = .random()
        stock.source = makeRandomSource(context: context)
        stock.symbolName = makeRandomSymbol(context: context)
        stock.isPinned = .random()
        stock.createdDate = Date()
        return stock
    }
    
    private static func makeRandomSource(context: Context) -> Source
    {
        let source = Source(context: context)
        source.valueType = .random()
        source.value = .random(in: -10e10 ..< 10e10)
        return source
    }
    
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
        condition.comparisonType = .random()
        condition.priorityType = .random()
        
        condition.leftHand = makeRandomSource(context: context)
        condition.rightHand = makeRandomSource(context: context)
        condition.symbolName = makeRandomSymbol(context: context)
        
        // events (the events that this condition triggers)
        condition.events = NSSet(array: [makeRandomEvent(context: context)])
        
        return condition
    }
    
    // MARK: - Flow
    
    
    // MARK: - Events
    
    private static func makeRandomEvent(context: Context) -> Event
    {
        let event = Event(context: context)
        event.conditionType = .allCases.randomElement()!
        event.isActive = .random()
        event.symbolName = makeRandomSymbol(context: context)
        event.history = NSSet(array: makeRandomHistories(context: context))
        
        for _ in 0 ..< Int.random(in: 0 ... 3)
        {
            let note = makeRandomNote(context: context)
            event.addToNotes(note)
        }

        for _ in 0 ..< Int.random(in: 0 ... 3)
        {
            let condition = makeRandomCondition(context: context)
            event.addToConditions(condition)
        }
        
        return event
    }
    
    // MARK: - Blocks
    
    private static func makeRandomBlock(context: Context) -> Block
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
    
    private static func makeRandomUnit(context: Context) -> Unit
    {
        let unit = Unit(context: context)
        unit.isBase = Bool.random()
        unit.abbreviation = faker.lorem.characters(amount: 3)
        unit.symbolName = makeRandomSymbol(context: context)
        
        if Bool.random()
        {
            for _ in 0 ..< Int.random(in: 0 ... 3)
            {
                let derivedUnit = makeRandomUnit(context: context)
                unit.addToChildren(derivedUnit)
            }
        }
        
        return unit
    }
    
    // MARK: - Conversion
    
    private static func makeRandomConversion(context: Context) -> Conversion
    {
        let conversion = Conversion(context: context)
        conversion.isReversible = Bool.random()
        conversion.leftValue = Double.random(in: -10e10 ... 10e10)
        conversion.rightValue = Double.random(in: -10e10 ... 10e10)
        conversion.symbolName = makeRandomSymbol(context: context)
        return conversion
    }
    
    // MARK: - Color
    
    private static func makeRandomColor(context: Context) -> Color
    {
        let color = Color(context: context)
        
        color.brightness = Double.random(in: 0 ... 1)
        color.hue = Double.random(in: 0 ... 1)
        color.saturation = Double.random(in: 0 ... 1)
        
        return color
    }
    
    // MARK: - Notes
    
    private static func makeRandomNote(context: Context) -> Note
    {
        // first and second line are transient (i.e generated from the blocks, right?)
        
        let note = Note(context: context)
        
        // Add blocks
        for _ in 0 ..< Int.random(in: 0 ... 10)
        {
            note.addToBlocks(makeRandomBlock(context: context))
        }
        
        // Add subnotes
        if Bool.random()
        {
            for _ in 0 ..< Int.random(in: 0 ... 3)
            {
                note.addToSubnotes(makeRandomNote(context: context))
            }
        }
        
        // Find related notes
        if Bool.random()
        {
            let relatedNotes = NSSet(array: getRandomNote(context: context, limit: Int.random(in: 0 ... 5)))
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
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    // MARK: - History
    
    private static func makeRandomHistory(context: Context) -> History
    {
        let history = History(context: context)
        
        let endRange = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
        let interval = TimeInterval.random(in: 0 ..< endRange)
        
        history.date = Date(timeIntervalSince1970: interval)
        history.eventType = .random()
        history.source = makeRandomSource(context: context) // TODO: Could be better?
        
        return history
    }
    
    private static func makeRandomHistories(context: Context, limit: Int = 10) -> [History]
    {
        var histories: [History] = []
        
        for _ in 0 ..< Int.random(in: 0 ... limit)
        {
            histories.append(makeRandomHistory(context: context))
        }
        
        return histories
    }
    
    // MARK: - Systems
    
    private static func makeRandomSystem(context: Context) -> System
    {
        let system = System(context: context)
        system.symbolName = makeRandomSymbol(context: context)
        
        let randomStocks = getRandomStocks(context: context, max: .random(in: 1 ... 4))
        let stocks = NSSet(array: randomStocks)
        system.addToStocks(stocks)
        
        // Set events
        // Set flows
        // Set notes
        // Set stocks
        
        // Suggested flows?
        
        return system
    }
}
