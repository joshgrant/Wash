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
    
    weak var sender: UIButton?
    var entityType: Entity.Type
    
    // MARK: - Initialization
    
    init(sender: UIButton, entityType: Entity.Type)
    {
        self.sender = sender
        self.entityType = entityType
    }
}
