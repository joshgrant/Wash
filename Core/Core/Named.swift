//
//  Named.swift
//  Core
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public protocol Named
{
    var unwrappedName: String? { get }
    var managedObjectContext: Context? { get }
}

public extension Named
{
    var title: String
    {
        get {
            unwrappedName ?? ""
        }
    }
}
