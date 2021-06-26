//
//  Unique.swift
//  Walnut
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

protocol Unique: Hashable
{
    var id: UUID { get set }
}

extension Unique
{
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool
    {
        lhs.id == rhs.id
    }
}
