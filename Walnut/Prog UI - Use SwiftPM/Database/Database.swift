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
    
    private func populate(context: Context)
    {
        delegate?.populate(context: context)
        context.quickSave()
    }
    
    public func createContext() -> Context
    {
        let container = try! Container(modelName: "Model")
        try! container.loadPersistentStores()
        populate(context: container.context)
        return container.context
    }
    
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
