//
//  System+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData

@objc(System)
public class System: Entity {
    
}


extension System: Named {}
extension System: Pinnable {}

// MARK: - Utility

extension System
{
    var unwrappedStocks: [Stock] { unwrapped(\System.stocks) }
    var unwrappedFlows: [Flow] { unwrapped(\System.flows) }
    var unwrappedNotes: [Note] { unwrapped(\System.notes) }

}

// MARK: - Fetching

extension System
{
    static func makeFetchRequest() -> NSFetchRequest<System>
    {
        System.fetchRequest()
    }
    
    static func allSystems(context: Context) -> [System]
    {
        let request = Self.makeFetchRequest()
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
    
    static func priorityFetchRequest() -> NSFetchRequest<System>
    {
        let request: NSFetchRequest<System> = System.fetchRequest()
        request.predicate = NSPredicate(format: "ideal < 100")
        request.sortDescriptors = [NSSortDescriptor(key: "ideal", ascending: true)]
        request.fetchLimit = 5
        return request
    }
}

// Automatically Generated

extension System {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<System> {
        return NSFetchRequest<System>(entityName: "System")
    }
    
    // Transient property
    // TODO: This is a naive implementation: in reality, stocks
    // have a min/max value so each has a certain "percentage"
    // We need to calculate this "percentage" based on ideal and current
    // and then return the total of all "current" percentages divided by
    // ideal percentages (100%).
    public var ideal: Double
    {
        var runningTotalCurrent: Double = 0
        var runningTotalIdeal: Double = 0
        
        for stock in unwrappedStocks
        {
            runningTotalCurrent += stock.source?.value ?? 0
            runningTotalIdeal += stock.ideal?.value ?? 0
        }
        
        return (runningTotalCurrent / runningTotalIdeal) * 100
    }
    
    @NSManaged public var flows: NSSet?
    @NSManaged public var stocks: NSSet?
    @NSManaged public var symbolName: Symbol?
    @NSManaged public var tasks: NSSet?
    
}

// MARK: Generated accessors for flows
extension System {
    
    @objc(addFlowsObject:)
    @NSManaged public func addToFlows(_ value: Flow)
    
    @objc(removeFlowsObject:)
    @NSManaged public func removeFromFlows(_ value: Flow)
    
    @objc(addFlows:)
    @NSManaged public func addToFlows(_ values: NSSet)
    
    @objc(removeFlows:)
    @NSManaged public func removeFromFlows(_ values: NSSet)
    
}

// MARK: Generated accessors for stocks
extension System {
    
    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)
    
    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)
    
    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)
    
    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)
    
}

// MARK: Generated accessors for tasks
extension System {
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}
