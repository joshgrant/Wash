////
////  Command+NonStateModifying.swift
////  Wash
////
////  Created by Josh Grant on 4/7/22.
////
//
//import Foundation
//import CoreData
//
//extension Command
//{
//    func allRunningFlows(context: Context) -> [Entity]
//    {
//        let result = Flow.runningFlows(in: context)
//        
//        for flow in result
//        {
//            if flow.isHidden { continue }
//            print(flow.runningDescription)
//        }
//        
//        return result
//    }
//    
//    func allHidden(context: Context) -> [Entity]
//    {
//        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
//        request.predicate = NSPredicate(format: "isHidden == true")
//        let result = (try? context.fetch(request)) ?? []
//        print(result)
//        return result
//    }
//    
//    func runPinned(context: Context, shouldPrint: Bool = true) -> [Entity]
//    {
//        let request = Entity.makePinnedObjectsFetchRequest(context: context)
//        let result = (try? context.fetch(request)) ?? []
//        let pins = result.compactMap { $0 as? Pinnable }
//        if shouldPrint { print("Pins: \(pins)") }
//        return pins
//    }
//    
//    func runLibrary(context: Context) -> [Entity]
//    {
//        for type in EntityType.libraryVisible
//        {
//            let count = type.count(in: context)
//            print("\(type.icon.text) \(type.title) (\(count))")
//        }
//        return []
//    }
//    
//    func runAll(entityType: EntityType, context: Context) -> [Entity]
//    {
//        let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
//        request.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
//        let result = (try? context.fetch(request)) ?? []
//        guard result.count > 0 else {
//            print("No results")
//            return []
//        }
//        
//        for item in result.enumerated()
//        {
//            if let entity = item.element as? Named
//            {
//                print("\(item.offset): \(entity)")
//            }
//        }
//        
//        return result as? [Entity] ?? []
//    }
//    
//    func runUnbalanced(context: Context, shouldPrint: Bool = true) -> [Entity]
//    {
//        let requestStock: NSFetchRequest<Stock> = Stock.fetchRequest()
//        requestStock.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
//        let resultStock = (try? context.fetch(requestStock)) ?? []
//        let unbalancedStocks = resultStock.filter { $0.percentIdeal < Stock.thresholdPercent }
//        if shouldPrint { print("Unbalanced Stocks: \(unbalancedStocks)") }
//        
//        let requestSystem: NSFetchRequest<System> = System.fetchRequest()
//        requestSystem.predicate = NSPredicate(format: "isHidden == false && deletedDate == nil")
//        let resultSystem = (try? context.fetch(requestSystem)) ?? []
//        let unbalancedSystems = resultSystem.filter { $0.percentIdeal < Stock.thresholdPercent }
//        if shouldPrint { print("Unbalanced Systems: \(unbalancedSystems)") }
//        
//        return unbalancedStocks + unbalancedSystems
//    }
//    
//    func runPriority(context: Context, shouldPrint: Bool = true) -> [Entity]
//    {
//        var suggested: Set<Flow> = []
//        let allStocks: [Stock] = Stock.all(context: context)
//        let unbalancedStocks = allStocks.filter { stock in
//            stock.percentIdeal <= Stock.thresholdPercent
//        }
//        
//        for stock in unbalancedStocks
//        {
//            var bestFlow: Flow?
//            var bestPercentIdeal: Double = 0
//            
//            let allFlows = (stock.unwrappedInflows + stock.unwrappedOutflows).filter { !$0.isRunning }
//            
//            for flow in allFlows
//            {
//                if flow.isHidden { continue }
//                
//                let amount: Double
//                
//                // TODO: Could clean this up a bit
//                if stock.unwrappedInflows.contains(where: { $0 == flow })
//                {
//                    amount = flow.amount
//                }
//                else if stock.unwrappedOutflows.contains(where: { $0 == flow })
//                {
//                    amount = -flow.amount
//                }
//                else
//                {
//                    print("Something's wrong: flow wasn't part of inflows or outflows")
//                    fatalError()
//                }
//                
//                let projectedCurrent = min(stock.max, stock.current + amount)
//                let projectedPercentIdeal = Double.percentDelta(
//                    a: projectedCurrent,
//                    b: stock.target,
//                    minimum: stock.min,
//                    maximum: stock.max)
//                if projectedPercentIdeal > bestPercentIdeal
//                {
//                    bestFlow = flow
//                    bestPercentIdeal = projectedPercentIdeal
//                }
//            }
//            
//            if let flow = bestFlow
//            {
//                suggested.insert(flow)
//            }
//        }
//        
//        if shouldPrint { print("Priority: \(suggested)") }
//        return Array(suggested)
//    }
//    
//    func runEvents(context: Context) -> [Entity]
//    {
//        let events = Event.activeAndSatisfiedEvents(context: context)
//        for event in events
//        {
//            print(event)
//        }
//        return events
//    }
//    
//    func runFlowsNeedingCompletion(context: Context) -> [Entity]
//    {
//        let flows: [Flow] = Flow.all(context: context)
//        let flowsNeedingCompletion = flows.filter { flow in
//            flow.needsUserExecution && !flow.isHidden && flow.deletedDate == nil
//        }
//        for flow in flowsNeedingCompletion {
//            print(flow)
//        }
//        return flowsNeedingCompletion
//    }
//}
