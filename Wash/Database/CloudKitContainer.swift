//
//  CloudKitContainer.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/12/21.
//

import CoreData

public typealias CloudKitContainer = NSPersistentCloudKitContainer

public extension CloudKitContainer
{
    // MARK: - Variables
    
    var context: Context { viewContext }
    var model: Model { managedObjectModel }
    var coordinator: Coordinator { persistentStoreCoordinator }
    
    // MARK: - Initialization
    
    convenience init(modelName: String) throws
    {
        guard let modelURL = Self.getModelURL(modelName: modelName) else
        {
            throw DatabaseError.nilModelURL
        }
        
        guard let model = Model(contentsOf: modelURL) else
        {
            throw DatabaseError.nilModel
        }
        
        self.init(name: modelName, managedObjectModel: model)
    }
    
    static func getModelURL(modelName: String) -> URL?
    {
        Bundle.main.url(forResource: "Model", withExtension: "momd")
    }
    
    func loadPersistentStores() throws
    {
        loadPersistentStores { [unowned self] description, error in
            
            self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            if let error = error as NSError?
            {
                fatalError("\(error.userInfo)")
            }
        }
    }
}
