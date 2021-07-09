//
//  LinkSearchCriteria.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import CoreData

/// This is the class that encapsulates the data that exists in a search query
/// Essentially, if there's an entity, (or Entity), the text, and any filters
/// The only restriction is that we have some way of sorting the Entities...
class LinkSearchCriteria
{
    // MARK: - Variables
    
    var searchString: String
    var entityType: NamedEntity.Type
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(
        searchString: String,
        entityType: NamedEntity.Type,
        context: Context?)
    {
        self.searchString = searchString
        self.entityType = entityType
        self.context = context
    }
    
    // MARK: - Functions
    
    func makeFetchPredicate() -> NSPredicate
    {
        if searchString.count > 0
        {
            let format = "name.name CONTAINS[c] %@"
            return NSPredicate(format: format, searchString)
        }
        else
        {
            return NSPredicate(value: true)
        }
    }
    
    func makeSortDescriptors() -> [NSSortDescriptor]
    {
        return [
            NSSortDescriptor(key: "name.name", ascending: true)
        ]
    }
    
    func makeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityType.entity()
        fetchRequest.predicate = makeFetchPredicate()
        fetchRequest.sortDescriptors = makeSortDescriptors()
        fetchRequest.fetchLimit = 25
        return fetchRequest
    }
    
    func makeFetchResultsController() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        return .init(
            fetchRequest: makeFetchRequest(),
            managedObjectContext: context!,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
}
