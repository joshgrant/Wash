//
//  LinkSearchControllerTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit
import CoreData

class LinkSearchControllerTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Variables
    
    var tableView: UITableView
    var tableViewDataSourceReference: UITableViewDiffableDataSourceReference!
    var searchCriteria: LinkSearchCriteria
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    weak var context: Context?
    
    var shouldAnimate: Bool = false
    
    // MARK: - Initialization
    
    init(entityType: NamedEntity.Type, context: Context?)
    {
        self.tableView = UITableView(frame: .zero, style: .plain)
                
        self.context = context
        
        let searchCriteria = LinkSearchCriteria(
            searchString: "",
            entityType: entityType,
            context: context)
        
        self.searchCriteria = searchCriteria
        
        super.init()
        
        let cellProvider: UITableViewDiffableDataSourceReferenceCellProvider = { [weak self] tableView, indexPath, id in
            let result = self?.fetchResultsController.fetchedObjects?[indexPath.row]
            
            guard let result = result as? Named else {
                fatalError("What the crap")
            }
            
            let model = RightImageCellModel(title: result.title, detail: .link, disclosure: false)
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
        let message = TableViewSelectionMessage(
            tableView: tableView,
            indexPath: indexPath,
            token: .linkSearch)
        AppDelegate.shared.mainStream.send(message: message)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = fetchResultsController.fetchedObjects?[indexPath.row]
        
        guard let result = result as? Named else {
            fatalError("What the crap")
        }
        
        let model = RightImageCellModel(title: result.title, detail: .link, disclosure: false)
        return model.makeCell(in: tableView, at: indexPath)
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
