//
//  DashboardListBuilder.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import UIKit

class DashboardListBuilder: ListControllerBuilder<DashboardSection, DashboardItem>
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    weak var delegate: SuggestedItemDelegate?
    
    /// The reason this is necessary is to call the `registration` function so that it's created BEFORE the
    /// cell provider. Otherwise, we'll get an error that the registration is being created every time (not true)
    var headerRegistration = HeaderItem.registration
    var pinnedRegistration = PinnedItem.registration
    var suggestedRegistration = SuggestedItem.registration
    var forecastRegistration = ForecastItem.registration
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    override func makeCellProvider() -> CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.headerRegistration,
                    for: indexPath,
                    item: item)
            case .pinned(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.pinnedRegistration,
                    for: indexPath,
                    item: item)
            case .suggested(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.suggestedRegistration,
                    for: indexPath,
                    item: item)
            case .forecast(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.forecastRegistration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    override func makeInitialModel() -> ListModel
    {
        [
            .pinned: makePinnedItems(),
            .suggested: makeSuggestedItems(),
            .forecast: makeForecastItems()
        ]
    }
    
    private func makePinnedItems() -> [DashboardItem]
    {
        var items: [DashboardItem] = []
        
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        do
        {
            let result = try context.fetch(request)
            items = result.compactMap { item in
                guard let pin = item as? Pinnable else { return nil }
                guard let type = EntityType.type(from: pin) else { return nil }
                let pinnedItem = PinnedItem(text: pin.title, image: type.icon.image, entity: pin)
                return DashboardItem.pinned(pinnedItem)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
        
        let headerItem = DashboardItem.header(.init(text: .pinned, image: Icon.pinFill.image))
        items.insert(headerItem, at: 0)
        
        return items
    }
    
    private func makeSuggestedItems() -> [DashboardItem]
    {
        // 1. Get unbalanced stocks
        // 2. Find the flows that affect those stocks
        // 3. Sort the flows by impact
        // 4. return the highest impact flow
        
        var items: [DashboardItem] = []
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
                let simulatedCurrent = stock.source!.value + amount
                let simulatedPercentDelta = Double.percentDelta(
                    a: simulatedCurrent,
                    b: stock.ideal!.value,
                    minimum: stock.minimum!.value,
                    maximum: stock.maximum!.value)
                let deltaSimulatedActual = abs(stock.percentIdeal - simulatedPercentDelta)
                if deltaSimulatedActual > bestDelta
                {
                    bestFlow = flow
                    bestDelta = deltaSimulatedActual
                }
            }
            
            if let flow = bestFlow
            {
                suggested.append(flow)
            }
        }
        
        items = suggested.map { flow in
            let item = SuggestedItem(
                text: flow.title,
                secondaryText: "\(flow.amount)",
                checked: false,
                entity: flow,
                delegate: delegate)
            return .suggested(item)
        }
        
        let header = DashboardItem.header(.init(text: .suggested, image: Icon.flow.image))
        items.insert(header, at: 0)
        
        return items
    }
    
    private func makeForecastItems() -> [DashboardItem]
    {
        var items: [DashboardItem] = []
        
        let request = Event.makeUpcomingEventsFetchRequest()
        do
        {
            let result = try context.fetch(request)
            items = result.compactMap { event in
                let item = ForecastItem(
                    text: event.title,
                    secondaryText: "Date goes here",
                    event: event)
                return .forecast(item)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
        
        let headerItem = DashboardItem.header(.init(text: .forecast, image: Icon.forecast.image))
        items.insert(headerItem, at: 0)
        
        return items
    }
}

extension DashboardListBuilder: ViewControllerTabBarDelegate
{
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.image }
    var tabBarTag: Int { 0 }
    
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

extension DashboardListBuilder: DashboardListFactory
{
    func makeRefreshButton(target: DashboardListResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.refresh.image,
            style: .plain,
            target: target,
            action: #selector(target.handleRefresh(_:)))
    }
    
    func makeSpinnerButton() -> UIBarButtonItem
    {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        return UIBarButtonItem(customView: spinner)
    }
    
    func makeRouter() -> DashboardListRouter
    {
        .init(context: context, stream: stream)
    }
}
