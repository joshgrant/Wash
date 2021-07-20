//
//  DashboardListControllerBuilder.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

protocol DashboardListControllerFactory: Factory & ViewControllerTabBarDelegate
{
    func makeCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration
    func makeCollectionViewLayout() -> UICollectionViewLayout
    func makeCollectionView() -> UICollectionView
    
    func makeCellProvider() -> UICollectionViewDiffableDataSource<ListSection, DashboardPinnedListItem>.CellProvider
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<ListSection, DashboardPinnedListItem>
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
        .init(appearance: .grouped)
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        let configuration = makeCollectionLayoutListConfiguration()
        return UICollectionViewCompositionalLayout.list(using: configuration)
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
    
    func makeCellProvider() -> UICollectionViewDiffableDataSource<ListSection, DashboardPinnedListItem>.CellProvider
    {
        return { collectionView, indexPath, item in
            let registration = item.cellRegistration
            return collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item)
        }
    }
    
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<ListSection, DashboardPinnedListItem>
    {
        let cellProvider = makeCellProvider()
        return .init(collectionView: collectionView, cellProvider: cellProvider)
    }
}
