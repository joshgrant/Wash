//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

protocol LibraryControllerFactory: ViewControllerTabBarDelegate, Factory
{
    func makeRouter() -> LibraryTableViewRouter
    func makeTableView() -> TableView<LibraryTableViewContainer>
}

class LibraryControllerContainer: DependencyContainer
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }
    
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
}

extension LibraryControllerContainer: LibraryControllerFactory
{
    func makeRouter() -> LibraryTableViewRouter
    {
        let container = LibraryTableViewRouterContainer(
            context: context,
            stream: stream)
        return LibraryTableViewRouter(container: container)
    }
    
    func makeTableView() -> TableView<LibraryTableViewContainer>
    {
        let container = LibraryTableViewContainer(
            context: context,
            stream: stream,
            style: .grouped)
        return container.makeTableView()
    }
    
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

class LibraryController: ViewController<LibraryControllerContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    var tableView: TableView<LibraryTableViewContainer>
    var router: LibraryTableViewRouter
    
    // MARK: - Initialization
    
    required init(container: LibraryControllerContainer)
    {
        self.tableView = container.makeTableView()
        self.router = container.makeRouter()
        super.init(container: container)
        router.delegate = self
        subscribe(to: container.stream)
    }

    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tabBarItem = container.makeTabBarItem()
        title = container.tabBarItemTitle
        
        view.embed(tableView)
    }
}

extension LibraryController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case is EntityListDeleteMessage:
            fallthrough
        case is EntityListAddButtonMessage:
            tableView.shouldReload = true
        default:
            break
        }
    }
}
