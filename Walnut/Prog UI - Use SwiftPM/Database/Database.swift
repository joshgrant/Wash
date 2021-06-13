//
//  Database.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import CoreData

open class Database
{
    // MARK: - Variables
    
    weak var delegate: DatabaseDelegate?
    
    func getItemsForList<T: NSManagedObject>(context: Context, type: T.Type) -> [T]
    {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(type))
        do {
            return try context.fetch(fetchRequest)
        } catch {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    func getItemInList<T: NSManagedObject>(at indexPath: IndexPath, context: Context, type: T.Type) -> T?
    {
        let items = getItemsForList(context: context, type: type)
        return items[indexPath.row]
    }
}
