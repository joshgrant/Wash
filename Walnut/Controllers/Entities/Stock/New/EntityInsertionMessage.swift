//
//  EntityInsertionMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/19/21.
//

import Foundation

class EntityInsertionMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}
