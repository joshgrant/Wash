//
//  EntityListAddButtonMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class EntityListAddButtonMessage: Message
{
    // MARK: - Variables
    
    weak var sender: AnyObject?
    var entityType: Entity.Type
    
    // MARK: - Initialization
    
    init(sender: AnyObject, entityType: Entity.Type)
    {
        self.sender = sender
        self.entityType = entityType
    }
}
