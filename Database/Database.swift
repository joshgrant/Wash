//
//  Database.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation
import Cocoa
import CoreData

public typealias Container = NSPersistentContainer

open class Database
{
    // MARK: - Defined types
    
    private enum Constants
    {
        static let modelName = "Model"
    }
    
    // MARK: - Variables
    
    public var container: Container
    public var context: Context { container.viewContext }
    
    // MARK: - Initialization
    
    public init()
    {
        container = Self.createContainer()
        populate(context: context)
    }
    
    // MARK: Factory
    
    /// Separating the container creation allows us to destroy and re-init the container.
    static func createContainer(modelName: String = Constants.modelName) -> Container
    {
        let model = NSManagedObjectModel.mergedModel(from: nil)!
        let container = Container(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { description, error in
            
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            if let error = error as NSError?
            {
                fatalError("\(error.userInfo)")
            }
        }
        
        return container
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
        populate(context: container.viewContext)
    }
}
