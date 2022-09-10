//
//  Insertable.swift
//  Wash
//
//  Created by Joshua Grant on 9/9/22.
//

import Foundation

protocol Insertable
{
    associatedtype T: Entity
    
    static func insert(name: String, into context: Context) -> T
}
