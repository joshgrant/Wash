//
//  LinkSearchController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit

protocol LinkSearchControllerFactory: Factory
{
    func makeController() -> LinkSearchController
    func makeTableViewManager() -> LinkSearchControllerTableViewManager
    func makeSearchController(delegate: UISearchControllerDelegate,
                              manager: LinkSearchControllerTableViewManager) -> UISearchController
    func makeAddButton(target: LinkSearchController) -> UIBarButtonItem
}

class LinkSearchControllerContainer: DependencyContainer
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    var origin: LinkSearchController.Origin
    var hasAddButton: Bool
    var entityType: NamedEntity.Type
    
    // MARK: - Initialization
    
    init(
        context: Context,
        stream: Stream,
        origin: LinkSearchController.Origin,
        hasAddButton: Bool,
        entityType: NamedEntity.Type)
    {
        self.context = context
        self.stream = stream
        self.origin = origin
        self.hasAddButton = hasAddButton
        self.entityType = entityType
    }
}

extension LinkSearchControllerContainer: LinkSearchControllerFactory
{
    func makeController() -> LinkSearchController
    {
        .init(container: self)
    }
    
    func makeTableViewManager() -> LinkSearchControllerTableViewManager
    {
        let container = LinkSearchControllerTableViewManagerContainer(
            entityType: entityType,
            origin: origin,
            context: context,
            stream: stream)
        return .init(container: container)
    }
    
    func makeSearchController(
        delegate: UISearchControllerDelegate,
        manager: LinkSearchControllerTableViewManager) -> UISearchController
    {
        let controller = UISearchController(searchResultsController: nil)
        controller.delegate = delegate
        controller.searchResultsUpdater = manager
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }
    
    // TODO: Use responder protocol instead
    func makeAddButton(target: LinkSearchController) -> UIBarButtonItem
    {
        let button = UIBarButtonItem(systemItem: .add)
        button.target = target
        button.action = #selector(target.addButtonDidTouchUpInside(_:))
        return button
    }
}

// The wrapping view controller
// TODO: Need to dismiss this from the presenting controller
class LinkSearchController: ViewController<LinkSearchControllerContainer>
{
    // MARK: - Defined types
    
    enum Origin
    {
        case stockFrom
        case stockTo
        case systemStockSearch
        case stockDimension
        case newStock
        case newUnit(id: UUID)
    }
    
    // MARK: - Variables
    
    var tableViewManager: LinkSearchControllerTableViewManager

    // MARK: - Initialization
    
    required init(container: LinkSearchControllerContainer)
    {
        tableViewManager = container.makeTableViewManager()
        super.init(container: container)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.embed(tableViewManager.tableView)

        navigationItem.searchController = container.makeSearchController(delegate: self, manager: tableViewManager)
        navigationItem.hidesSearchBarWhenScrolling = false // It's not scrolled to top...
        
        if container.hasAddButton
        {
            navigationItem.rightBarButtonItem = container.makeAddButton(target: self)
        }
        
        title = container.entityType.readableName
        
        tableViewManager.configureFetchResultsController()
    }
    
    // TODO: These view lifecycle methods are scaryy....
    // the problem is that the table view doesn't know how
    // to automatically reload...
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableViewManager.shouldAnimate = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        tableViewManager.shouldAnimate = false
    }
    
    // MARK: - UI Action
    
    @objc func addButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        // Route to the entity "new" screen
        guard let detail = EntityType
                .type(
                    from: container.entityType)?
                .newController(
                    context: container.context,
                    stream: container.stream) else
        {
            assertionFailure("Failed to get the detail controller")
            return 
        }
        
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension LinkSearchController: UISearchControllerDelegate
{
    
}
