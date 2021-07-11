//
//  LinkSelectionMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

class LinkSelectionMessage: Message
{
    var entity: Entity
    var origin: LinkSearchController.Origin
    
    init(entity: Entity, origin: LinkSearchController.Origin)
    {
        self.entity = entity
        self.origin = origin
    }
}
