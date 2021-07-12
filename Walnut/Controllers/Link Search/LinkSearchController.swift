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
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var tableViewManager: LinkSearchControllerTableViewManager
    weak var context: Context?
    weak var _stream: Stream?
    var stream: Stream { return _stream ?? AppDelegate.shared.mainStream }
    
    // MARK: - Initialization
    
    init(
        origin: Origin,
        entity: Entity,
        entityType: NamedEntity.Type,
        context: Context?,
        _stream: Stream? = nil)
    {
        self._stream = _stream
        
        tableViewManager = LinkSearchControllerTableViewManager(
            origin: origin,
            entityToLinkTo: entity,
            entityLinkType: entityType,
            context: context,
            _stream: _stream)
        
        self.context = context
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: stream)
        
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
    
    deinit {
        unsubscribe(from: stream)
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
