//
//  File.swift
//  
//
//  Created by Joshua Grant on 6/12/21.
//

import Foundation

public enum DatabaseError: Error
{
    case nilModelURL
    case nilModel
    case failedToLoadPersistentStores
}
