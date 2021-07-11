//
//  EntityListDeleteMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class EntityListDeleteMessage: Message
{
    var entity: Entity
    var indexPath: IndexPath
    
    init(entity: Entity, indexPath: IndexPath)
    {
        self.entity = entity
        self.indexPath = indexPath
    }
}
