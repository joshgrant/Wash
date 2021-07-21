//
//  DashboardListControllerBuilder.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit
import CoreData

protocol DashboardListControllerFactory: Factory & ViewControllerTabBarDelegate
{
    func makeCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration
    func makeCollectionViewLayout() -> UICollectionViewLayout
    func makeCollectionView() -> UICollectionView
    
    func makeCellProvider() -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>.CellProvider
    
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>
}

protocol DashboardListControllerContainer: DependencyContainer
{
    var context: Context { get set }
    var stream: Stream { get set }
}

class DashboardListControllerBuilder: DashboardListControllerFactory & DashboardListControllerContainer
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
    
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Factory
    
    func makeCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration
    {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .firstItemInSection
//        configuration.headerMode = .supplementary // TODO: Maybe?
        return configuration
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        let configuration = makeCollectionLayoutListConfiguration()
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    func makeCollectionView() -> UICollectionView
    {
        let layout = makeCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        return collectionView
    }
    
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
    
    func makeCellProvider() -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>.CellProvider
    {
        return { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                let registration = item.cellRegistration
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            case .pinned(let item):
                let registration = item.cellRegistration
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            case .suggestedFlow(let item):
                let registration = item.cellRegistration
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }
    }
    
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>
    {
        let cellProvider = makeCellProvider()
        return .init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    // MARK: - Functions
    
    func makeInitialSnapshot() -> NSDiffableDataSourceSnapshot<DashboardSection, DashboardItem>
    {
        var snapshot = NSDiffableDataSourceSnapshot<DashboardSection, DashboardItem>()
        
        snapshot.appendSections([.pinned,
                                 .priority,
                                 .suggested,
                                 .forecast])
        
        snapshot.appendItems(makeSuggestedFlowItems(), toSection: .suggested)
        
        return snapshot
    }
    
    func pinnedSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<DashboardItem>
    {
        var snapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
        let header = DashboardItem.header(.pinned)
        let items = makePinnedItems()
        snapshot.append([header])
        snapshot.append(items, to: header)
        snapshot.expand([header])
        return snapshot
    }
    
    func flowSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<DashboardItem>
    {
        var snapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
        let header = DashboardItem.header(.flows)
        let items = makeSuggestedFlowItems()
        snapshot.append([header])
        snapshot.append(items, to: header)
        snapshot.expand([header])
        return snapshot
    }
    
    private func makePinnedItems() -> [DashboardItem]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        
        do
        {
            let result = try context.fetch(request)
            return result.compactMap { item in
                guard let pin = item as? Pinnable else { return nil }
                guard let type = EntityType.type(from: pin) else { return nil }
                let item = RightImageListItem(entity: pin, text: pin.title, icon: type.icon, disclosure: true)
                return .pinned(item)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    private func makeSuggestedFlowItems() -> [DashboardItem]
    {
        let fakeContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        fakeContext.parent = context
        
        let first = SubtitleCheckboxListItem(
            entity: TransferFlow(context: fakeContext),
            text: "Hello",
            secondaryText: "Sup",
            isChecked: true,
            disclosure: true)
        
        let second = SubtitleCheckboxListItem(
            entity: TransferFlow(context: fakeContext),
            text: "Good day, mate, how are you?",
            secondaryText: "This is a long label so let's see how it goes",
            isChecked: false,
            disclosure: false)
        
        return [.suggestedFlow(first), .suggestedFlow(second)]
        
        //        let request = Flow.makeDashboardSuggestedFlowsFetchRequest()
        //
        //        do
        //        {
        //            let result = try context.fetch(request)
        //            return result.compactMap { flow in
        //                // We're only fetching flows with suggestions
        //                let firstSuggestion: System = flow.unwrapped(\Flow.suggestedIn).first!
        //                let item = SubtitleCheckboxListItem(
        //                    entity: flow,
        //                    text: flow.title,
        //                    secondaryText: firstSuggestion.title,
        //                    isChecked: false, // When we check it, the flow is run, so it should remove it from the list?
        //                    disclosure: true)
        //                return .suggestedFlow(item)
        //            }
        //        }
        //        catch
        //        {
        //            assertionFailure(error.localizedDescription)
        //            return []
        //        }
        //    }
    }
}
