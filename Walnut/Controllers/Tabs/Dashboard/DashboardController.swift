//
//  DashboardController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit

class DashboardController: ViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
    
    var tableView: DashboardTableView
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: UINavigationController)
    {
        self.tableView = DashboardTableView(context: context)
        
        super.init()
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = tabBarItemTitle
        tabBarItem = makeTabBarItem()
        
        view.embed(tableView)
    }
}

extension DashboardController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

extension DashboardController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case is EntityPinnedMessage:
            tableView.shouldReload = true
        case let m as TableViewEntitySelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewEntitySelectionMessage)
    {
        guard let _ = message.tableView as? DashboardTableView else { return }
        
        let detailController = message
            .entity
            .detailController()
        
        navigationController?.pushViewController(detailController, animated: true)
    }
}
