//
//  LinkSearchControllerTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit
import CoreData

protocol LinkSearchControllerTableViewManagerFactory: Factory
{
    func makeSearchCriteria() -> LinkSearchCriteria
    func makeTableView() -> UITableView
}

class LinkSearchControllerTableViewManagerContainer: DependencyContainer
{
    // MARK: - Variables
    
    var entityType: NamedEntity.Type
    var origin: LinkSearchController.Origin
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(entityType: NamedEntity.Type, origin: LinkSearchController.Origin, context: Context, stream: Stream)
    {
        self.entityType = entityType
        self.origin = origin
        self.context = context
        self.stream = stream
    }
}

extension LinkSearchControllerTableViewManagerContainer: LinkSearchControllerTableViewManagerFactory
{
    func makeSearchCriteria() -> LinkSearchCriteria
    {
        .init(searchString: "", entityType: entityType, context: context)
    }
    
    func makeTableView() -> UITableView
    {
        .init(frame: .zero, style: .plain)
    }
}

class LinkSearchControllerTableViewManager: NSObject, UITableViewDelegate
{
    // MARK: - Variables
    
//    var entity: Entity
    
    // TODO: MAYBE we can make a tableViewModel that uses
    // a fetched results controller as a base
    
    var container: LinkSearchControllerTableViewManagerContainer
    
    var tableView: UITableView
    var tableViewDataSourceReference: UITableViewDiffableDataSourceReference!
    var searchCriteria: LinkSearchCriteria
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var shouldAnimate: Bool = false
    
    // MARK: - Initialization
    
    init(container: LinkSearchControllerTableViewManagerContainer)
    {
        self.container = container
        self.tableView = container.makeTableView()
        self.searchCriteria = container.makeSearchCriteria()
        
        super.init()
        
        let cellProvider: UITableViewDiffableDataSourceReferenceCellProvider = { [weak self] tableView, indexPath, id in
            let result = self?.fetchResultsController.fetchedObjects?[indexPath.row]
            
            guard let result = result as? Named else {
                fatalError("What the crap")
            }
            
            let model = RightImageCellModel(
                selectionIdentifier: .link(link: result),
                title: result.title,
                detail: .link,
                disclosure: false)
            return model.makeCell(in: tableView, at: indexPath)
        }
        
        self.tableViewDataSourceReference = .init(tableView: tableView, cellProvider: cellProvider)
        
        tableView.register(RightImageCell.self, forCellReuseIdentifier: RightImageCellModel.cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = tableViewDataSourceReference
    }
    
    // MARK: - Configuration
    
    func configureFetchResultsController()
    {
        fetchResultsController = searchCriteria.makeFetchResultsController()
        fetchResultsController.delegate = self
        try! fetchResultsController.performFetch()
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let link = fetchResultsController.item(at: indexPath) as! Entity
        let message = LinkSelectionMessage(link: link, origin: container.origin)
        container.stream.send(message: message)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LinkSearchControllerTableViewManager: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        searchCriteria.searchString = searchController.searchBar.text ?? ""
        configureFetchResultsController()
    }
}

extension LinkSearchControllerTableViewManager: NSFetchedResultsControllerDelegate
{
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference)
    {
        tableViewDataSourceReference.applySnapshot(snapshot, animatingDifferences: shouldAnimate)
    }
}
