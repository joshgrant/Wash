//
//  CancelCreationMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class CancelCreationMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}
