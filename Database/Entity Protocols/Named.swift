//
//  Named.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation

protocol Named: Entity
{
    var unwrappedName: String? { get }
    var managedObjectContext: Context? { get }
}

extension Named
{
    var title: String
    {
        get {
            unwrappedName ?? ""
        }
    }
}
