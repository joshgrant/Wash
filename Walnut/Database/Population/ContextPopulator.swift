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
    static var sinkId = UUID(uuidString: "5AB9D2AA-3A20-4771-B923-71BDD93E53E3")!
    static var sourceId = UUID(uuidString: "8F710523-FD11-406C-AA97-C71B625C031B")!
    
    static func populate(context: Context)
    {
        fetchSourceStock(context: context)
        fetchSinkStock(context: context)
        context.quickSave()
    }
    
    @discardableResult private static func fetchSourceStock(context: Context) -> Stock
    {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Stock.uniqueID), sourceId as CVarArg)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "symbolName.name", ascending: true)]
        
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
        let source = Stock(context: context)
        source.uniqueID = sourceId
        source.amount = InfiniteSource(context: context)
        
        let symbol = Symbol(context: context)
        symbol.name = "Source".localized
        
        source.symbolName = symbol
        source.isPinned = true
        
        return source
    }
    
    @discardableResult private static func fetchSinkStock(context: Context) -> Stock
    {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Stock.uniqueID), sinkId as CVarArg)
//        fetchRequest.predicate = NSPredicate(
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "symbolName.name", ascending: true)]
        
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
    
    static private func makeSinkStock(context: Context) -> Stock
    {
        let sink = Stock(context: context)
        sink.uniqueID = sinkId
        sink.amount = InfiniteSource(context: context)
        
        let sinkSymbol = Symbol(context: context)
        sinkSymbol.name = "Sink".localized
        
        sink.symbolName = sinkSymbol
        sink.isPinned = true
        
        return sink
    }
}
