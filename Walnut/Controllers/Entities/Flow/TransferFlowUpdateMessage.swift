//
//  TransferFlowUpdateMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

class LinkSelectionMessage: Message
{
    var entity: Entity
    
    init(entity: Entity)
    {
        self.entity = entity
    }
}
