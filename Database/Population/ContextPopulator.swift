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
    // MARK: - Source & Sink
    
    static var sinkId = UUID(uuidString: "5AB9D2AA-3A20-4771-B923-71BDD93E53E3")!
    static var sourceId = UUID(uuidString: "8F710523-FD11-406C-AA97-C71B625C031B")!
    
    @discardableResult static func fetchOrMakeSourceStock(context: Context) -> Stock
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
    
    @discardableResult static func fetchOrMakeSinkStock(context: Context) -> Stock
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
}
