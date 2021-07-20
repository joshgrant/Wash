//
//  DashboardController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit

//protocol DashboardFactory: Factory
//{
//    func makeTableView() -> DashboardTableView
//}
//
//class DashboardDependencyContainer: DependencyContainer
//{
//    // MARK: - Variables
//
//    var context: Context
//    var stream: Stream
//
//    lazy var tableView: DashboardTableView = makeTableView()
//
//    // MARK: - Initialization
//
//    init(context: Context, stream: Stream)
//    {
//        self.context = context
//        self.stream = stream
//    }
//}

//extension DashboardDependencyContainer: DashboardFactory
//{
//    func makeTableView() -> DashboardTableView
//    {
//        let container = DashboardTableViewContainer(
//            stream: stream,
//            context: context,
//            style: .grouped)
//        return container.makeTableView()
//    }
//}

//class DashboardController: ViewController<DashboardDependencyContainer>
//{
//    // MARK: - Variables
//
//    var id = UUID()
//
//    // MARK: - Initialization
//
//    required init(container: DashboardDependencyContainer)
//    {
//        super.init(container: container)
//        subscribe(to: container.stream)
//    }
//
//    deinit
//    {
//        unsubscribe(from: container.stream)
//    }
//
//    // MARK: - View lifecycle
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        title = tabBarItemTitle
//        tabBarItem = makeTabBarItem()
//
//        view.embed(container.tableView)
//    }
//}
//
//extension DashboardController: ViewControllerTabBarDelegate
//{
//    var tabBarItemTitle: String { "Dashboard".localized }
//    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
//    var tabBarTag: Int { 0 }
//
//    func makeTabBarItem() -> UITabBarItem
//    {
//        UITabBarItem(
//            title: tabBarItemTitle,
//            image: tabBarImage,
//            tag: tabBarTag)
//    }
//}

//extension DashboardController: Subscriber
//{
//    func receive(message: Message)
//    {
//        switch message
//        {
//        case is EntityPinnedMessage,
//             is EntityListDeleteMessage,
//             is CancelCreationMessage,
//             is TextEditCellMessage:
//            container.tableView.shouldReload = true
//        case let m as TableViewEntitySelectionMessage:
//            handle(m)
//        default:
//            break
//        }
//    }
//    
//    private func handle(_ message: TableViewEntitySelectionMessage)
//    {
//        guard let _ = message.tableView as? DashboardTableView else { return }
//        
//        let detailController = message
//            .entity
//            .detailController(context: container.context, stream: container.stream)
//        
//        navigationController?.pushViewController(detailController, animated: true)
//    }
//}
