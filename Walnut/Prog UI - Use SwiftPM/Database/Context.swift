//
//  Context.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/12/21.
//

import CoreData

public typealias Context = NSManagedObjectContext

public extension Context
{
    func quickSave()
    {
        guard hasChanges else { return }
        
        perform
        {
            do
            {
                try self.save()
            }
            catch
            {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func performFetchRequest<T>(fetchRequest: NSFetchRequest<T>) -> [T]
    {
        do
        {
            let result = try fetch(fetchRequest)
            return result
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
}
