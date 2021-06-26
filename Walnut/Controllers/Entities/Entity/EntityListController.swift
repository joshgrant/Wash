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
    
    var tableViewModel: EntityListTableViewModel
    var tableView: TableView<EntityListTableViewModel>
    
    var tableViewNeedsReload: Bool = false
    
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
        let tableViewModel = EntityListTableViewModel(context: context, navigationController: navigationController, entityType: type)
        
        self.type = type
        self.context = context
        self.root = navigationController
        self.tableViewModel = tableViewModel
        self.tableView = TableView(model: tableViewModel)
        self.router = EntityListRouter(context: context, root: navigationController)
        self.responder = EntityListResponder(entityType: type)
        super.init(nibName: nil, bundle: nil)
        
        subscribe(to: AppDelegate.shared.mainStream)
        
        self.title = type.readableName.pluralize()
        
        navigationItem.rightBarButtonItem = makeBarButtonItem()
        navigationItem.searchController = makeSearchController(searchControllerDelegate: self)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder) {
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
        
        if tableViewNeedsReload
        {
            guard let model = tableViewModel.dataSource.model as? EntityListTableViewDataSourceModel
            else
            {
                assertionFailure("Incorrect table view data source model")
                return
            }
            model.reload()
            tableView.reloadData()
        }
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
            tableViewNeedsReload = true
        case is SystemDetailTitleEditedMessage:
            tableViewNeedsReload = true
        default:
            break
        }
    }
}
