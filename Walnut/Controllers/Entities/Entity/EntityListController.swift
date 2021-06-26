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
    
    var type: Entity.Type
    
    weak var context: Context?
    weak var root: NavigationController?
    
    var tableViewModel: EntityListTableViewModel
    var tableView: TableView<EntityListTableViewModel>
    
    lazy var responder: EntityListResponder = {
        .init(entityType: type)
    }()
    
    lazy var router: EntityListRouter = {
        .init(context: context, root: root)
    }()
    
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
        super.init(nibName: nil, bundle: nil)
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
        
//        if stateMachine.dirty
//        {
//            interactor.reload()
//            stateMachine.dirty = false
//        }
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
