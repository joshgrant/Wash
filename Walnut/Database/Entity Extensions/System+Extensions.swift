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
    
    // TODO: Need to weight the stock.amountValues / idealValue evenly?
    var percentIdeal: Int
    {
        let count = Double(unwrappedStocks.count)
        var total: Double = 0
        
        for stock in unwrappedStocks
        {
            total += calculateIdealPercent(stock: stock)
        }
        
        print(total)
        
        return Int(total / count)
    }
    
    /// Returns a value from 0 to 100
    func calculateIdealPercent(stock: Stock) -> Double
    {
        let amount = stock.amountValue
        let ideal = stock.idealValue
        
        if ideal == 0
        {
            return abs(ideal - amount)
        }
        
        return ideal - amount / ideal
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
