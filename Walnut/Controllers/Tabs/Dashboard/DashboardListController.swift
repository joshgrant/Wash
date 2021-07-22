//
//  DashboardListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import UIKit

class DashboardListBuilder: ListControllerBuilder<DashboardSection, DashboardItem>
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    weak var delegate: SuggestedItemDelegate?
    
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
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .pinned(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .suggested(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .forecast(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .priority(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    override func makeInitialModel() -> ListModel
    {
        [
            .pinned: makePinnedItems(),
            .suggested: [
                .header(.init(text: "Suggested Flows",
                              image: .init(systemName: "wind"))),
                .suggested(.init(text: "Wash dishes",
                                 secondaryText: "Chores",
                                 checked: false,
                                 delegate: delegate)),
                .suggested(.init(text: "Eat dinner",
                                 secondaryText: "Nutrition",
                                 checked: true,
                                 delegate: delegate))
            ],
            .forecast: [
                .header(.init(text: "Forecast",
                              image: .init(systemName: "calendar"))),
                .forecast(.init(text: "Charlie Horse 5k",
                                secondaryText: "Mon, Apr 3"))
            ],
            .priority: [
                .header(.init(text: "Priority",
                              image: .init(systemName: "network"))),
                .priority(.init(text: "Chores",
                                secondaryText: "25%"))
            ]
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
                let pinnedItem = PinnedItem(text: pin.title, image: type.icon.image)
                return DashboardItem.pinned(pinnedItem)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
        
        items.insert(.header(.init(text: .pinned, image: Icon.pinFill.image)), at: 0)
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

class DashboardListController: ListController<DashboardSection, DashboardItem, DashboardListBuilder>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    override init(builder: DashboardListBuilder)
    {
        super.init(builder: builder)
        subscribe(to: builder.stream)
        self.builder.delegate = self
        
        title = builder.tabBarItemTitle
        tabBarItem = builder.makeTabBarItem()
    }
    
    deinit
    {
        unsubscribe(from: builder.stream)
    }
    
    // MARK: - Functions
    
    @objc override func handleRefreshControl()
    {
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
        
        applyModel(animated: true)
        super.handleRefreshControl()
    }
    
    // MARK: - Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Get the entity
        // Send a message that the entity was selected
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension DashboardListController: SuggestedItemDelegate
{
    func suggestedItemUpdated(to checked: Bool, item: SuggestedItem)
    {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.suggested(item)])
        dataSource.apply(snapshot)
    }
}

extension DashboardListController: Subscriber
{
    func receive(message: Message)
    {
        print("Message: \(message)")
    }
}

/*
 
 // MARK: Flows
 
 func makeFlowsSection() -> TableViewSection
 {
 TableViewSection(
 header: .flows,
 models: makeFlowModels())
 }
 
 private func makeFlowModels() -> [TableViewCellModel]
 {
 let request = makeDashboardSuggestedFlowsFetchRequest()
 do
 {
 let result = try context.fetch(request)
 return result.map { flow in
 TextCellModel(
 selectionIdentifier: .flow(flow: flow),
 title: flow.title,
 disclosureIndicator: true)
 }
 }
 catch
 {
 assertionFailure(error.localizedDescription)
 return []
 }
 }
 
 // MARK: Forecast
 
 func makeForecastSection() -> TableViewSection
 {
 TableViewSection(
 header: .forecast,
 models: makeForecastModels())
 }
 
 private func makeForecastModels() -> [TableViewCellModel]
 {
 let request = makeDateSourcesFetchRequest()
 do
 {
 let result = try context.fetch(request)
 let events = Event.eventsFromSources(result)
 return events.map { event in
 DetailCellModel(
 selectionIdentifier: .event(event: event),
 title: event.title,
 detail: "FIX ME",
 disclosure: true)
 }
 }
 catch
 {
 assertionFailure(error.localizedDescription)
 return []
 }
 }
 
 // MARK: Priority
 
 func makePrioritySection() -> TableViewSection
 {
 TableViewSection(
 header: .priority,
 models: makePriorityModels())
 }
 
 private func makePriorityModels() -> [TableViewCellModel]
 {
 // TODO: Fetch unideal values
 // TODO: Sort on the ideal value, ascending
 
 let request: NSFetchRequest<System> = System.fetchRequest()
 request.predicate = NSPredicate(value: true)
 request.sortDescriptors = [NSSortDescriptor(key: "ideal", ascending: true)]
 
 do
 {
 let result = try context.fetch(request)
 return result.map { system in
 DetailCellModel(
 selectionIdentifier: .system(system: system),
 title: system.title,
 detail: "FIXME", // TODO: Should be the ideal value
 disclosure: true)
 }
 }
 catch
 {
 assertionFailure(error.localizedDescription)
 return []
 }
 }

 */
