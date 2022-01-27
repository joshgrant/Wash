//
//  DashboardDataSource.swift
//  Walnut
//
//  Created by Josh Grant on 1/27/22.
//

import Foundation
import Protyper

class DashboardDataSource
{
    // MARK: - Variables
    
    var context: Context
    
    var pinnedItems: [Pinnable] = []
    var forecast: [Event] = []
    var suggestedFlows: [Flow] = []
    
    // MARK: - Initialization
    
    init(context: Context)
    {
        self.context = context
    }
    
    // MARK: - Public functions
    
    public func reload()
    {
        pinnedItems = getPinned()
        forecast = getForecast()
        suggestedFlows = getSuggestedFlows()
    }
    
    public func entity(at section: Int, row: Int) -> Entity?
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
    
    // MARK: - Private functions
    
    private func getPinned() -> [Pinnable]
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
    
    private func getForecast() -> [Event]
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
    
    private func getSuggestedFlows() -> [Flow]
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

extension DashboardDataSource: TableViewDataSource
{
    func numberOfSections(in tableView: TableView) -> Int { 3 }
    
    func tableView(_ tableView: TableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return pinnedItems.count
        case 1:
            return forecast.count
        case 2:
            return suggestedFlows.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: TableView, cellForRowAt indexPath: Index) -> TableViewCell
    {
        let content: String
        
        switch indexPath.section
        {
        case 0:
            let item = pinnedItems[indexPath.row]
            content = "\(indexPath.row + 1): \(item)"
        case 1:
            let item = forecast[indexPath.row]
            content = "\(indexPath.row + 1): \(item)"
        case 2:
            let item = suggestedFlows[indexPath.row]
            content = "\(indexPath.row + 1): \(item)"
        default:
            fatalError("There shouldn't be 3 sections in the table view")
        }
        
        return TableViewCell(contentView: nil, accessories: [.label(text: content)])
    }
    
    func tableView(_ tableView: TableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "\(section). \(Icon.pinFill.text) PINNED"
        case 1:
            return "\(section). \(Icon.event.text) FORECAST"
        case 2:
            return "\(section). \(Icon.flow.text) SUGGESTED FLOWS"
        default:
            return nil
        }
    }
}
