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
    // MARK: - Variables
    
    var id = UUID()
    
    var tableViewManager: LinkSearchControllerTableViewManager
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(entityType: NamedEntity.Type, context: Context?)
    {
        tableViewManager = LinkSearchControllerTableViewManager(
            entityType: entityType,
            context: context)
        
        self.context = context
        
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

        title = entityType.readableName
        
        tableViewManager.configureFetchResultsController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableViewManager.shouldAnimate = true
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
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        if message.token == .linkSearch
        {
            dismiss(animated: true, completion: nil)
        }
    }
}
