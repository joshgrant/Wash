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
        var totalAmount: Double = 0
        var totalIdeal: Double = 0
        
        for stock in unwrappedStocks
        {
            totalAmount += stock.amountValue
            totalIdeal += stock.idealValue
        }
        
        // TODO: Recursively call on children systems
        
        let percent = totalAmount / totalIdeal
        return Int(percent * 100)
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
