//
//  EntityPinnedMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation

class EntityPinnedMessage: Message
{
    // MARK: - Variables
    
    var isPinned: Bool
    var entity: Entity
    
    // MARK: - Initialization
    
    init(isPinned: Bool, entity: Entity)
    {
        self.isPinned = isPinned
        self.entity = entity
    }
}
