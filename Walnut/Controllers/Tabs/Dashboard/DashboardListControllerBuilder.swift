//
//  DashboardListControllerBuilder.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit
import CoreData

//protocol DashboardListControllerFactory: Factory & ViewControllerTabBarDelegate
//{
//    func makeCollectionViewLayout() -> UICollectionViewLayout
//    func makeCollectionView() -> UICollectionView
//
//    func makeCellProvider() -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>.CellProvider
//
//    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>
//}
//
//protocol DashboardListControllerContainer: Container
//{
//    var context: Context { get set }
//    var stream: Stream { get set }
//}
//
//class DashboardListControllerBuilder: DashboardListControllerFactory & DashboardListControllerContainer
//{
//    // MARK: - Variables
//

//
//    var context: Context
//    var stream: Stream
//
//    // MARK: - Initialization
//
//    init(context: Context, stream: Stream)
//    {
//        self.context = context
//        self.stream = stream
//    }
//
//    // MARK: - Factory
//
//    func makeCollectionViewLayout() -> UICollectionViewLayout
//    {
//        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
//
//            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
//            configuration.headerMode = .supplementary
//            configuration.footerMode = .none
//
//            let section = NSCollectionLayoutSection.list(using: configuration,
//                                                         layoutEnvironment: layoutEnvironment)
//
//            return section
//        }
//
//        return layout
//    }
//
//    func makeCollectionView() -> UICollectionView
//    {
//        let layout = makeCollectionViewLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.delaysContentTouches = false
//        return collectionView
//    }
//

//
//    func makeCellProvider() -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>.CellProvider
//    {
//        return { collectionView, indexPath, item in
////            switch item
////            {
////            case .pinned(let item):
////                let registration = item.registration
////                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
////            case .suggested(let item):
////                let registration = item.registration
////                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
////            }
//            fatalError()
//        }
//    }
//
//    func makeSupplementaryRegistration() -> UICollectionView.SupplementaryRegistration<ListSectionHeader>
//    {
//        return .init(elementKind: UICollectionView.elementKindSectionHeader) { header, kind, indexPath in
//            switch kind
//            {
//            case UICollectionView.elementKindSectionHeader:
//                switch indexPath.section
//                {
//                case 0:
//                    let model = ListSectionHeaderModel(text: .pinned, icon: .pinFill)
//                    header.configure(with: model)
//                case 1:
//                    let model = ListSectionHeaderModel(text: .flows, icon: .flow)
//                    header.configure(with: model)
//                case 2:
//                    let model = ListSectionHeaderModel(text: .forecast, icon: .forecast)
//                    header.configure(with: model)
//                case 3:
//                    let model = ListSectionHeaderModel(text: .priority, icon: .priority)
//                    header.configure(with: model)
//                default:
//                    fatalError()
//                }
//            default:
//                break
//            }
//        }
//    }
//
//    func makeSupplementaryProvider() -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>.SupplementaryViewProvider
//    {
//        return { [unowned self] collectionView, kind, indexPath in
//            let registration = self.makeSupplementaryRegistration()
//            return collectionView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
//        }
//    }
//
//    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>
//    {
//        let cellProvider = makeCellProvider()
//        let dataSource = UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>(collectionView: collectionView, cellProvider: cellProvider)
//        dataSource.supplementaryViewProvider = makeSupplementaryProvider()
//        return dataSource
//    }
//
//    // MARK: - Functions
//
//    func makeInitialSnapshot() -> NSDiffableDataSourceSnapshot<DashboardSection, DashboardItem>
//    {
//        var snapshot = NSDiffableDataSourceSnapshot<DashboardSection, DashboardItem>()
//
//        snapshot.appendSections([.pinned,
//                                 .priority,
//                                 .suggested,
//                                 .forecast])
//
//        snapshot.appendItems(makePinnedItems(), toSection: .pinned)
//        snapshot.appendItems(makeSuggestedFlowItems(), toSection: .suggested)
//
//        return snapshot
//    }
//
////    func pinnedSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<DashboardItem>
////    {
////        var snapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
////        let header = DashboardItem.header(.pinned)
////        let items = makePinnedItems()
////        snapshot.append([header])
////        snapshot.append(items, to: header)
////        snapshot.expand([header])
////        return snapshot
////    }
////
////    func flowSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<DashboardItem>
////    {
////        var snapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
////        let header = DashboardItem.header(.flows)
////        let items = makeSuggestedFlowItems()
////        snapshot.append([header])
////        snapshot.append(items, to: header)
////        snapshot.expand([header])
////        return snapshot
////    }
//
//
//    private func makeSuggestedFlowItems() -> [DashboardItem]
//    {
////        let fakeContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
////        fakeContext.parent = context
////
////        let first = SubtitleCheckboxListItem(
////            entity: TransferFlow(context: fakeContext),
////            text: "Hello",
////            secondaryText: "Sup",
////            isChecked: true,
////            disclosure: true)
////
////        let second = SubtitleCheckboxListItem(
////            entity: TransferFlow(context: fakeContext),
////            text: "Good day, mate, how are you?",
////            secondaryText: "This is a long label so let's see how it goes",
////            isChecked: false,
////            disclosure: false)
////
////        return [.suggested(first), .suggested(second)]
//        return []
//
//        //        let request = Flow.makeDashboardSuggestedFlowsFetchRequest()
//        //
//        //        do
//        //        {
//        //            let result = try context.fetch(request)
//        //            return result.compactMap { flow in
//        //                // We're only fetching flows with suggestions
//        //                let firstSuggestion: System = flow.unwrapped(\Flow.suggestedIn).first!
//        //                let item = SubtitleCheckboxListItem(
//        //                    entity: flow,
//        //                    text: flow.title,
//        //                    secondaryText: firstSuggestion.title,
//        //                    isChecked: false, // When we check it, the flow is run, so it should remove it from the list?
//        //                    disclosure: true)
//        //                return .suggestedFlow(item)
//        //            }
//        //        }
//        //        catch
//        //        {
//        //            assertionFailure(error.localizedDescription)
//        //            return []
//        //        }
//        //    }
//    }
//}
