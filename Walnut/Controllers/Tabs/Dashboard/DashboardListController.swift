//
//  DashboardListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import UIKit

// TODO: Parent class that takes a generic factory and dependency container...

class DashboardListController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var builder: DashboardListControllerBuilder
    var collectionView: UICollectionView
    var dataSource: UICollectionViewDiffableDataSource<ListSection, DashboardPinnedListItem>
    
    // MARK: - Initialization
    
    required init(builder: DashboardListControllerBuilder)
    {
        let collectionView = builder.makeCollectionView()
        
        self.builder = builder
        self.collectionView = collectionView
        self.dataSource = builder.makeDataSource(collectionView: collectionView)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: builder.stream)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: builder.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = builder.tabBarItemTitle
        tabBarItem = builder.makeTabBarItem()
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        view.embed(collectionView)
        
        applyInitialSnapshot()
    }
    
    // MARK: - Functions
    
    func applyInitialSnapshot()
    {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, DashboardPinnedListItem>.init()
        
        let pinnedSection = ListSection.pinned
        
        snapshot.appendSections([
            pinnedSection
        ])
        snapshot.appendItems([
            DashboardPinnedListItem(text: "Cool", icon: .system, disclosure: true),
            DashboardPinnedListItem(text: "Lame", icon: .symbol, disclosure: true),
            DashboardPinnedListItem(text: "Suck", icon: .stock, disclosure: false)
        ], toSection: pinnedSection)
        
        dataSource.apply(snapshot)
    }
}

extension DashboardListController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // TODO: Send a message
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension DashboardListController: Subscriber
{
    func receive(message: Message)
    {
        // TODO:
        // When a pin message is received, reload
        // When a delete message is received, reload
        // When an entity is edited, reload
        // When an entity is selected (from this view) reload
    }
}
