//
//  DashboardListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import UIKit

protocol DashboardListFactory: Factory
{
    func makeRefreshButton(target: DashboardListResponder) -> UIBarButtonItem
    func makeSpinnerButton() -> UIBarButtonItem
    func makeRouter() -> DashboardListRouter
}

class DashboardListRouter
{
    var context: Context
    var stream: Stream
    
    weak var delegate: RouterDelegate?
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func routeToDetail(entity: Entity) {
        let detail = entity.detailController(
            context: context,
            stream: stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
}

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
            let item = SuggestedItem(text: flow.title, secondaryText: "\(flow.amount)", checked: false, delegate: delegate)
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
                let item = ForecastItem(text: event.title, secondaryText: "Date goes here")
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

@objc protocol DashboardListResponder
{
    func handleRefresh(_ sender: UIBarButtonItem)
}

class DashboardListController: ListController<DashboardSection, DashboardItem, DashboardListBuilder>
{
    // MARK: - Variables
    
    var router: DashboardListRouter
    
    var id = UUID()
    
    lazy var refreshButton = builder.makeRefreshButton(target: self)
    lazy var spinnerButton = builder.makeSpinnerButton()
    
    // MARK: - Initialization
    
    override init(builder: DashboardListBuilder)
    {
        self.router = builder.makeRouter()
        super.init(builder: builder)
        self.builder.delegate = self
        
        title = builder.tabBarItemTitle
        tabBarItem = builder.makeTabBarItem()
        
        navigationItem.rightBarButtonItem = refreshButton
        
        router.delegate = self
    }
    
    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // If it's in the pinned section, route to that pinned item
        let item = dataSource.itemIdentifier(for: indexPath)
        switch item {
        case .header(let header):
            print(header)
            // Route to the header item
        case .pinned(let pinned):
            print(pinned)
            // Route to the pinned item
            let item = pinned.entity
            router.routeToDetail(entity: item)
        case .forecast(let forecast):
            print(forecast)
            // Route to the forecast item
        case .suggested(let suggested):
            print(suggested)
            // Route to the suggested item
            
        case .none:
            assertionFailure("The item was nil.")
        }
        // If in the suggested section, route to that suggested item
        // If in the forecast section, route to the forecast
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension DashboardListController: RouterDelegate {}

extension DashboardListController: SuggestedItemDelegate
{
    func suggestedItemUpdated(to checked: Bool, item: SuggestedItem)
    {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.suggested(item)])
        dataSource.apply(snapshot)
    }
}

extension DashboardListController: DashboardListResponder
{
    @objc func handleRefresh(_ sender: UIBarButtonItem)
    {
        navigationItem.rightBarButtonItem = spinnerButton
        
        model = model.compactMapValues({ items in
            return items.compactMap { item in
                switch item
                {
                case .suggested(let item):
                    return item.checked ? nil : .suggested(item)
                default:
                    return item
                }
            }
        })
        
        applyModel(animated: true) { [unowned self] in
            self.navigationItem.rightBarButtonItem = refreshButton
        }
    }
}
