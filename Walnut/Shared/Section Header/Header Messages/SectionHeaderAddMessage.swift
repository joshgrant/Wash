//
//  SectionHeaderAddMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class SectionHeaderAddMessage: Message
{
    var entityToAddTo: Entity
    var entityType: Entity.Type
    
    init(entityToAddTo: Entity, entityType: Entity.Type)
    {
        self.entityToAddTo = entityToAddTo
        self.entityType = entityType
    }
}
