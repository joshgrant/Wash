//
//  DashboardController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit

class DashboardDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    var tableView: TableView
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream, tableView: TableView? = nil)
    {
        self.context = context
        self.stream = stream
        self.tableView = tableView ?? DashboardTableView(context: context)
    }
}

class DashboardController: ViewController<DashboardDependencyContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    override init(container: DashboardDependencyContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
        configureForDisplay()
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    private func configureForDisplay()
    {
        title = tabBarItemTitle
        tabBarItem = makeTabBarItem()
        
        view.embed(container.tableView)
    }
}

extension DashboardController: ViewControllerTabBarDelegate
{
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
    
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
        case is EntityPinnedMessage,
             is EntityListDeleteMessage,
             is CancelCreationMessage,
             is TextEditCellMessage:
            container.tableView.shouldReload = true
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
