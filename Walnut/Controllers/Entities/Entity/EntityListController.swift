//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit

class EntityListController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var type: Entity.Type
    
    weak var context: Context?
    
    var responder: EntityListResponder
    var router: EntityListRouter
    
    // Move these out of here?
    
    var tableView: EntityListTableView
    
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    init(
        type: Entity.Type,
        context: Context?)
    {
        self.type = type
        self.context = context
        self.tableView = EntityListTableView(entityType: type, context: context)
        self.router = .init(context: context)
        self.responder = .init(entityType: type)
        
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        self.title = type.readableName.pluralize()
        
        navigationItem.rightBarButtonItem = makeBarButtonItem()
        navigationItem.searchController = makeSearchController(searchControllerDelegate: self)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        view.embed(tableView)
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
            fallthrough
        case is TextEditCellMessage:
            tableView.shouldReload = true
        default:
            break
        }
    }
}
