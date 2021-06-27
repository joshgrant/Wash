//
//  TextEditCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation

class TextEditCellMessage: Message
{
    // MARK: - Variables
    
    var title: String
    var entity: Entity
    
    // MARK: - Initialization
    
    init(title: String, entity: Entity)
    {
        self.title = title
        self.entity = entity
    }
    
}
