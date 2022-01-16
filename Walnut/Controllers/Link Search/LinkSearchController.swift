//
//  LinkSearchController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import UIKit
import CoreData

protocol LinkSearchControllerDelegate: AnyObject
{
    func didSelectEntity(entity: Entity, controller: LinkSearchController)
}

class LinkSearchController: ViewController<LinkSearchControllerContainer>, UITableViewDelegate
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
        case unit
    }
    
    // MARK: - Variables
    
    var tableView: UITableView
    var searchCriteria: LinkSearchCriteria
    var dataSourceReference: UITableViewDiffableDataSourceReference
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>
    var shouldAnimate: Bool = false
    
    weak var delegate: LinkSearchControllerDelegate?

    // MARK: - Initialization
    
    required init(container: LinkSearchControllerContainer)
    {
        let tableView = container.makeTableView()
        let searchCriteria = container.makeSearchCriteria()
        let fetchResultsController = container.makeFetchResultsController(searchCriteria: searchCriteria)
    
        self.tableView = tableView
        self.searchCriteria = searchCriteria
        self.fetchResultsController = fetchResultsController
        
        dataSourceReference = container.makeDataSourceReference(tableView: tableView, fetchController: fetchResultsController)
        
        super.init(container: container)
    }
    
    // MARK: - View lifecycle
    
    override func loadView()
    {
        tableView.register(RightImageCell.self,
                           forCellReuseIdentifier: RightImageCellModel.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = dataSourceReference
        
        view = tableView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.searchController = container.makeSearchController(
            delegate: self,
            manager: self)
        navigationItem.hidesSearchBarWhenScrolling = false // It's not scrolled to top...
        
        if container.hasAddButton
        {
            navigationItem.rightBarButtonItem = container.makeAddButton(target: self)
        }
        
        title = container.entityType.readableName
        
        fetchResultsController.delegate = self
        try! fetchResultsController.performFetch()
    }
    
    // TODO: These view lifecycle methods are scaryy....
    // the problem is that the table view doesn't know how
    // to automatically reload...
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        shouldAnimate = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        shouldAnimate = false
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
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let link = fetchResultsController.item(at: indexPath) as! Entity
        let message = LinkSelectionMessage(link: link, origin: container.origin)
        container.stream.send(message: message)
        delegate?.didSelectEntity(entity: link, controller: self)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension LinkSearchController: UISearchControllerDelegate
{
    
}

extension LinkSearchController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        searchCriteria.searchString = searchController.searchBar.text ?? ""
        
    }
}

extension LinkSearchController: NSFetchedResultsControllerDelegate
{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference)
    {
        dataSourceReference.applySnapshot(snapshot, animatingDifferences: shouldAnimate)
    }
}
