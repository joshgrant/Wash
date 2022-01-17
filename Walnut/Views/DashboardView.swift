//
//  DashboardView.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation

class DashboardView: View
{
    var context: Context
    
    var pinnedItems: [Pinnable] = []
    var forecast: [Event] = []
    var suggestedFlows: [Flow] = []
    
    init(context: Context)
    {
        self.context = context
    }
    
    func reload()
    {
        pinnedItems = getPinned()
        forecast = getForecast()
        suggestedFlows = getSuggestedFlows()
    }
    
    func display()
    {
        reload()
        /// 1. Pinned
        print("1. \(Icon.pinFill.textIcon()) PINNED")
        print("–––––––––––––––––––––––––––––––––")
        for item in pinnedItems.enumerated()
        {
            print("\(item.offset + 1): \(item.element)")
        }
        print("")
        
        /// 2. Forecast
        print("2. \(Icon.event.textIcon()) FORECAST")
        print("–––––––––––––––––––––––––––––––––")
        for item in forecast.enumerated()
        {
            print("\(item.offset + 1): \(item.element.dashboardDescription)")
        }
        print("")
        
        /// 3. Suggested Flows
        print("3. \(Icon.flow.textIcon()) SUGGESTED FLOWS")
        print("–––––––––––––––––––––––––––––––––")
        for item in suggestedFlows.enumerated()
        {
            print("\(item.offset + 1): \(item.element.dashboardDescription)")
        }
        print("")
    }
    
    func handle(section: Int?, row: Int?, command: String?)
    {
        print(section ?? -1, row ?? -1, command ?? "")
        
        switch (section, row, command)
        {
        case (_, _, "h"):
            print("No help yet, sorry.")
        case (.some(let s), .some(let r), "pin"):
            let entity = entity(at: s, row: r)
            entity?.isPinned = true
        case (.some(let s), .some(let r), "unpin"):
            let entity = entity(at: s, row: r)
            entity?.isPinned = false
        case (.some(let s), .some(let r), "delete"):
            if let entity = entity(at: s, row: r)
            {
                entity.managedObjectContext?.delete(entity)
                entity.managedObjectContext?.quickSave()
            }
        case (.some(let s), .some(let r), nil):
            let entity = entity(at: s, row: r)
            // Route to detail screen
            print("Routing to detail screen of: \(entity)")
        default:
            print("Invalid command. Press 'h' for help.")
        }
    }
    
    func entity(at section: Int, row: Int) -> Entity?
    {
        switch section
        {
        case 1:
            return pinnedItems[row - 1]
        case 2:
            return forecast[row - 1]
        case 3:
            return suggestedFlows[row - 1]
        default:
            assertionFailure("Invalid section: \(section)")
            return nil
        }
    }
    
    // MARK: - Builders
    
    func getPinned() -> [Pinnable]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        do
        {
            let result = try context.fetch(request)
            return result.compactMap { item in
                guard let pin = item as? Pinnable else { return nil }
                return pin
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    func getForecast() -> [Event]
    {
        let request = Event.makeUpcomingEventsFetchRequest()
        do
        {
            let result = try context.fetch(request)
            return result
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    func getSuggestedFlows() -> [Flow]
    {
        var suggested: [Flow] = []
        let allStocks: [Stock] = Stock.all(context: context)
        let unbalancedStocks = allStocks.filter { stock in
            stock.percentIdeal < 100
        }
        
        for stock in unbalancedStocks
        {
            var bestFlow: Flow?
            var bestDelta: Double = 0
            
            let allFlows = stock.unwrappedInflows + stock.unwrappedOutflows
            
            for flow in allFlows
            {
                let amount = flow.amount
                let projectedCurrent = stock.source!.value + amount
                let projectedDelta = Double.percentDelta(a: projectedCurrent, b: stock.ideal!.value, minimum: stock.minimum!.value, maximum: stock.maximum!.value)
                let deltaProjectedActual = abs(stock.percentIdeal - projectedDelta)
                if deltaProjectedActual > bestDelta
                {
                    bestFlow = flow
                    bestDelta = deltaProjectedActual
                }
            }
            
            if let flow = bestFlow
            {
                suggested.append(flow)
            }
        }
        
        return suggested
    }
}
