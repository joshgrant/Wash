//
//  LinkSearchController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit

// The wrapping view controller
class LinkSearchController: UIViewController
{
    // MARK: - Defined types
    
    enum Origin
    {
        case stockFrom
        case stockTo
        case systemStockSearch
        case stockDimension
        case newStock
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var tableViewManager: LinkSearchControllerTableViewManager
    weak var context: Context?
    
    var origin: Origin
    var hasAddButton: Bool
    var entityType: NamedEntity.Type
//    var entity: Entity
    
    // MARK: - Initialization
    
    init(
        origin: Origin,
//        entity: Entity,
        entityType: NamedEntity.Type,
        context: Context?,
        hasAddButton: Bool = false)
    {
        self.origin = origin
//        self.entity = entity
        self.entityType = entityType
        self.context = context
        self.hasAddButton = hasAddButton
        
        tableViewManager = LinkSearchControllerTableViewManager(
            origin: origin,
//            entityToLinkTo: entity,
            entityLinkType: entityType,
            context: context)
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableViewManager.tableView)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = tableViewManager
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // It's not scrolled to top...
        
        if hasAddButton
        {
            let barButtonItem = UIBarButtonItem(systemItem: .add)
            barButtonItem.target = self
            barButtonItem.action = #selector(addButtonDidTouchUpInside(_:))
            navigationItem.rightBarButtonItem = barButtonItem
        }

        title = entityType.readableName
        
        tableViewManager.configureFetchResultsController()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - View lifecycle
    
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
        guard let detail = EntityType.type(from: entityType)?.newController(context: context) else
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

extension LinkSearchController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as LinkSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        dismiss(animated: true, completion: nil)
    }
}
