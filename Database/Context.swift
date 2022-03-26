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
    // MARK: - Functions
    
    func quickSave()
    {
        guard hasChanges else { return }
        
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
