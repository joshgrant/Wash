//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryController: ViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }

    var router: LibraryTableViewRouter
    var tableView: LibraryTableView
    
    // MARK: - Initialization

    init(
        context: Context,
        navigationController: UINavigationController)
    {
        self.router = LibraryTableViewRouter(context: context)
        self.tableView = LibraryTableView(context: context)
        
        super.init()
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        tabBarItem = makeTabBarItem()
        title = tabBarItemTitle
        
        view.embed(tableView)
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
}

extension LibraryController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
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
