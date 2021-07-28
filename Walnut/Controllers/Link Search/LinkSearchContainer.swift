//
//  LinkSearchContainer.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit
import CoreData

protocol LinkSearchControllerFactory: Factory
{
    func makeController() -> LinkSearchController
    
    func makeSearchCriteria() -> LinkSearchCriteria
    func makeTableView() -> UITableView
    
    func makeSearchController(delegate: UISearchControllerDelegate,
                              manager: LinkSearchController) -> UISearchController // HMM: Not flexible enough
    
    func makeAddButton(target: LinkSearchController) -> UIBarButtonItem
    
    func makeCellProvider(fetchController: NSFetchedResultsController<NSFetchRequestResult>) -> UITableViewDiffableDataSourceReferenceCellProvider
    func makeDataSourceReference(tableView: UITableView, fetchController: NSFetchedResultsController<NSFetchRequestResult>) -> UITableViewDiffableDataSourceReference
    func makeFetchResultsController(searchCriteria: LinkSearchCriteria) -> NSFetchedResultsController<NSFetchRequestResult>
}

class LinkSearchControllerContainer: Container
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
    
    func makeSearchCriteria() -> LinkSearchCriteria
    {
        .init(
            searchString: "",
            entityType: entityType,
            context: context)
    }
    
    func makeTableView() -> UITableView
    {
        .init(frame: .zero, style: .plain)
    }
    
    func makeSearchController(
        delegate: UISearchControllerDelegate,
        manager: LinkSearchController) -> UISearchController
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
    
    func makeCellProvider(fetchController: NSFetchedResultsController<NSFetchRequestResult>) -> UITableViewDiffableDataSourceReferenceCellProvider
    {
        { tableView, indexPath, id in
            let result = fetchController.fetchedObjects?[indexPath.row]
            
            guard let result = result as? Named else {
                fatalError()
            }
            
            let model = RightImageCellModel(
                selectionIdentifier: .link(link: result),
                title: result.title,
                detail: .link,
                disclosure: false)
            
            return model.makeCell(in: tableView, at: indexPath)
        }
    }
    
    func makeDataSourceReference(tableView: UITableView, fetchController: NSFetchedResultsController<NSFetchRequestResult>) -> UITableViewDiffableDataSourceReference
    {
        .init(
            tableView: tableView,
            cellProvider: makeCellProvider(fetchController: fetchController))
    }
    
    func makeFetchResultsController(searchCriteria: LinkSearchCriteria) -> NSFetchedResultsController<NSFetchRequestResult>
    {
        return searchCriteria.makeFetchResultsController()
    }
}
