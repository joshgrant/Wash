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
//        return Flow(context: self.managedObjectContext!)
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
        
        if count == 0 { return 100 }
        
        return Int(total / count)
    }
    
    /// Returns a value from 0 to 100
    func calculateIdealPercent(stock: Stock) -> Double
    {
//        let minimum = stock.minimumValue
//        let maximum = stock.maximumValue
//        let current = stock.amountValue
//        let ideal = stock.idealValue
//
//        // Use minimum and maximum to establish range for both current and ideal
//        // Then, return the delta between the two
//
//        let range = maximum - minimum
//
//        let currentPercent = range - current / range
//        let idealPercent = range - ideal / range
//
//        return idealPercent - currentPercent / idealPercent
        
        return 100
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
