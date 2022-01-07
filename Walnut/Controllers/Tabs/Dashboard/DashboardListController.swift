//
//  DashboardListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import UIKit

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
        case .pinned(let pinned):
            router.routeToDetail(entity: pinned.entity)
        case .forecast(let forecast):
            router.routeToDetail(entity: forecast.event)
        case .suggested(let suggested):
            router.routeToDetail(entity: suggested.entity)
        case .header, .none:
            break
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
