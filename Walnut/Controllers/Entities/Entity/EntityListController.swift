//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit

class EntityListController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var type: Entity.Type
    
    weak var context: Context?
    weak var root: NavigationController?
    
    var tableViewManager: EntityListTableViewManager
    var responder: EntityListResponder
    var router: EntityListRouter
    
    // Move these out of here?
    
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    init(
        type: Entity.Type,
        context: Context,
        navigationController: NavigationController)
    {
        self.type = type
        self.context = context
        self.root = navigationController
        self.tableViewManager = .init(
            entityType: type,
            context: context,
            navigationController: navigationController)
        self.router = .init(context: context, root: navigationController)
        self.responder = .init(entityType: type)
        
        super.init(nibName: nil, bundle: nil)
        
        subscribe(to: AppDelegate.shared.mainStream)
        
        self.title = type.readableName.pluralize()
        
        navigationItem.rightBarButtonItem = makeBarButtonItem()
        navigationItem.searchController = makeSearchController(searchControllerDelegate: self)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        view.embed(tableViewManager.tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBarButtonItem() -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: addButtonImage,
            style: addButtonStyle,
            target: responder,
            action: #selector(responder.userTouchedUpInsideAddButton(sender:)))
    }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableViewManager.reloadIfNeeded()
    }
    
    // MARK: - Factory
    
    func makeSearchController(searchControllerDelegate: UISearchControllerDelegate) -> UISearchController
    {
        // TODO: Make a better results controller
        let searchResultsController = UIViewController()
        searchResultsController.view.backgroundColor = .green
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = searchControllerDelegate
        return searchController
    }
}

extension EntityListController: UISearchControllerDelegate
{
    
}

extension EntityListController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case is EntityListAddButtonMessage:
            tableViewManager.needsReload = true
        case is SystemDetailTitleEditedMessage:
            tableViewManager.needsReload = true
        default:
            break
        }
    }
}
