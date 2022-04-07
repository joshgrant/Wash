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
    
    static var yearId = UUID(uuidString: "9C2BE585-06D8-42C6-8342-CE5D03BBFA9E")!
    static var monthId = UUID(uuidString: "6AFB57E9-1C9F-46F0-B04D-B19649775693")!
    static var dayId = UUID(uuidString: "1EA0C9BE-5D40-4AA3-9ACA-53DC49C140BB")!
    static var hourId = UUID(uuidString: "A0AA7B90-5C4F-4857-8FDE-A5F876F9EB4E")!
    static var minuteId = UUID(uuidString: "0989768A-904A-4F23-B328-8B7F0E5E86FE")!
    static var secondId = UUID(uuidString: "722B7171-EC1D-4839-A155-BBF9BA1C914D")!
    
    // MARK: - Generic
    
    static func fetchOrMakeStock(
        context: Context,
        name: String,
        id: UUID,
        valueType: SourceValueType,
        value: Double,
        min: Double,
        max: Double,
        ideal: Double,
        isPinned: Bool = false
    ) -> Stock
    {
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Stock.uniqueID), id as CVarArg)
        
        do
        {
            guard let stock = try context.fetch(request).first else
            {
                return makeStock(
                    context: context,
                    name: name,
                    id: id,
                    valueType: valueType,
                    value: value,
                    min: min,
                    max: max,
                    ideal: ideal,
                    isPinned: isPinned)
            }
            
            return stock
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    static func makeStock(
        context: Context,
        name: String,
        id: UUID,
        valueType: SourceValueType,
        value: Double,
        min: Double,
        max: Double,
        ideal: Double,
        isPinned: Bool = false
    ) -> Stock
    {
        let stock = Stock(context: context)
        stock.uniqueID = id
        
        let source = Source(context: context)
        source.valueType = valueType
        source.value = value
        
        stock.source = source
        
        stock.minimum = Source(context: context)
        stock.minimum?.value = min
        
        stock.maximum = Source(context: context)
        stock.maximum?.value = max
        
        stock.ideal = Source(context: context)
        stock.ideal?.value = ideal
        
        let symbol = Symbol(context: context)
        symbol.name = name
        
        stock.symbolName = symbol
        stock.isPinned = isPinned
        
        return stock
    }
}

// MARK: - Concrete instances

extension ContextPopulator
{
    static func sourceStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Source".localized,
            id: ContextPopulator.sourceId,
            valueType: .infinite,
            value: .infinity,
            min: -.infinity,
            max: .infinity,
            ideal: -.infinity,
            isPinned: true)
    }
    
    static func sinkStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Sink".localized,
            id: ContextPopulator.sinkId,
            valueType: .infinite,
            value: -.infinity,
            min: -.infinity,
            max: .infinity,
            ideal: .infinity,
            isPinned: true)
    }
    
    static func yearStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Year".localized,
            id: ContextPopulator.yearId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
    
    static func monthStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Month".localized,
            id: ContextPopulator.monthId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
    
    static func dayStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Day".localized,
            id: ContextPopulator.dayId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
    
    static func hourStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Hour".localized,
            id: ContextPopulator.hourId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
    
    static func minuteStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Minute".localized,
            id: ContextPopulator.minuteId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
    
    static func secondStock(context: Context) -> Stock
    {
        ContextPopulator.fetchOrMakeStock(
            context: context,
            name: "Second".localized,
            id: ContextPopulator.secondId,
            valueType: .number,
            value: 0,
            min: -.infinity,
            max: .infinity,
            ideal: 0)
    }
}
