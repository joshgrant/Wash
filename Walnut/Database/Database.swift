//
//  Database.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation
import Cocoa
import CoreData

open class Database
{
    // MARK: - Variables
    
    public var modelName: String
    public var container: CloudKitContainer
    
    public var context: Context { container.context }
    
    // MARK: - Initialization
    
    public init(modelName: String = "Model")
    {
        self.modelName = modelName
        
        do
        {
            container = try CloudKitContainer(modelName: modelName)
            try container.loadPersistentStores()
        }
        catch
        {
            fatalError("Failed to create the container: \(error)")
        }
        
        populate(context: context)
    }
    
    // MARK: - Functions
    
    public func getItemsForList<T: NSManagedObject>(context: Context, type: T.Type) -> [T]
    {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(type))
        do {
            return try context.fetch(fetchRequest)
        } catch {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    public func getItemInList<T: NSManagedObject>(at indexPath: IndexPath, context: Context, type: T.Type) -> T?
    {
        let items = getItemsForList(context: context, type: type)
        return items[indexPath.item]
    }
}

public extension Database
{
    func populate(context: Context)
    {
        context.quickSave()
    }
}
