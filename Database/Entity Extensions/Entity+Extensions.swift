//
//  Entity+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData

public extension Entity
{
    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        self.createdDate = Date()
    }
}

public extension Entity
{
    func unwrapped<E, T: Hashable, K: Hashable>(_ keypath: KeyPath<E, T>) -> [K]
    {
        guard let self = self as? E else {
            assertionFailure("Failed to cast self to the correct type: \(E.self)")
            return []
        }
        
        guard let set = self[keyPath: keypath] as? NSSet else {
            assertionFailure("Failed to extract the NSSet from the keypath")
            return []
        }
        
        guard let unwrapped = set as? Set<K> else {
            assertionFailure("Failed to unwrap \(keypath) on the object")
            return []
        }
        
        return Array(unwrapped)
    }
}

public extension Entity
{
    static func makePinnedObjectsPredicate() -> NSPredicate
    {
        NSPredicate(format: "isPinned == true && isHidden == false && deletedDate == nil")
    }
    
    static func makePinnedObjectsSortDescriptors() -> [NSSortDescriptor]
    {
        [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: false)]
    }
    
    static func makePinnedObjectsFetchRequest(context: Context) -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        fetchRequest.predicate = makePinnedObjectsPredicate()
        fetchRequest.sortDescriptors = makePinnedObjectsSortDescriptors()
        fetchRequest.fetchBatchSize = 20
        fetchRequest.shouldRefreshRefetchedObjects = true
        return fetchRequest
    }
}

extension Entity
{
    static var entityName: String
    {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        
        if let last = components.last
        {
            return last
        }
        else
        {
            assertionFailure("Failed to extract the entity name")
            return ""
        }
    }
    
    static func all<T: Entity>(context: Context) -> [T]
    {
        let request = NSFetchRequest<T>(entityName: entityName)
        do
        {
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
}
