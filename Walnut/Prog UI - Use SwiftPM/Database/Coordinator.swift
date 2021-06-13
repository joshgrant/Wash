//
//  Coordinator.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/12/21.
//

import CoreData

public typealias Coordinator = NSPersistentStoreCoordinator

public extension Coordinator
{
    func erase() throws
    {
        for store in persistentStores
        {
            if let path = store.url?.path
            {
                try FileManager.default.removeItem(atPath: path)
            }
            
            try remove(store)
        }
    }
}
