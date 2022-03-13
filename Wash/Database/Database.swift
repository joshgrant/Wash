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
    // MARK: - Defined types
    
    private enum Constants
    {
        static let modelName = "Model"
    }
    
    // MARK: - Variables
    
    public var container: CloudKitContainer
    
    public var context: Context { container.context }
    
    // MARK: - Initialization
    
    public init()
    {
        container = Self.createContainer()
        populate(context: context)
    }
    
    // MARK: Factory
    
    /// Separating the container creation allows us to destroy and re-init the container.
    static func createContainer(modelName: String = Constants.modelName) -> CloudKitContainer
    {
        do
        {
            let container = try CloudKitContainer(modelName: modelName)
            try container.loadPersistentStores()
            return container
        }
        catch
        {
            fatalError("Failed to create the container: \(error)")
        }
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
    
    func clear()
    {
        let coordinator = container.persistentStoreCoordinator
        
        for store in coordinator.persistentStores
        {
            try! coordinator.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
        }
        
        container = Self.createContainer()
    }
}
