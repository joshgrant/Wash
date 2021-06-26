//
//  System+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData

extension System: Named {}
extension System: Pinnable {}

// MARK: - Utility

extension System
{
//    var suggestedFlow: Flow?
//    {
//        // Finding the suggested flow means figuring out which flow
//        // has the most net positive impact on the percent ideal
//        return TransferFlow(context: self.managedObjectContext!)
//    }
    
    var unwrappedStocks: [Stock] { unwrapped(\System.stocks) }
    var unwrappedFlows: [Flow] { unwrapped(\System.flows) }
    var unwrappedEvents: [Event] { unwrapped(\System.events) }
    var unwrappedNotes: [Note] { unwrapped(\System.notes) }
    
    var percentIdeal: Int
    {
        // To find the ideal, we need to figure out the ideal value
        // for all of the systems underneath + the current one
        
        // To find the ideal of the current system, take all of the stocks
        // and check how ideal they are
        
        // To really verify this, we have to have both subsystems
        // and stocks...
        // Maybe we should come up with a data generator?
        
        let total: Int = 0
        
//        for stock in unwrappedStocks
//        {
//            let amount = stock.currentValue
//            let ideal = stock.idealValue
//           // TODO: Calculate the delta
//        }
        
        // TODO: Recursively call on children systems
        
        return total
    }
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
}
