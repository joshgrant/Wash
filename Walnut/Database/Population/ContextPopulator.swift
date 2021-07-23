//
//  ContextPopulator.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import CoreData

class ContextPopulator
{
    static func populate(context: Context)
    {
        fetchOrMakeSourceStock(context: context)
        fetchOrMakeSinkStock(context: context)
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
    
    private static func makeRandomStock(context: Context) -> Stock
    {
        let stock = Stock(context: context)
        stock.stateMachine = Bool.random()
        stock.source = makeRandomSource(context: context)
        
        return stock
    }
    
    private static func makeRandomSource(context: Context) -> Source
    {
        let source = Source(context: context)
        source.valueType = .random()
        source.value = .random(in: -.greatestFiniteMagnitude ..< .greatestFiniteMagnitude)
        return source
    }
}
