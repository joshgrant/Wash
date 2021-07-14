//
//  RightEditCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class RightEditCellMessage: Message
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var content: String
    
    // MARK: - Initialization
    
    init(selectionIdentifier: SelectionIdentifier, content: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.content = content
    }
}
