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
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var entity: Entity
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        entity: Entity)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.entity = entity
    }
    
}
