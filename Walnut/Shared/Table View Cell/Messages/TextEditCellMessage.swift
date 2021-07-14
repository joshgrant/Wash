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
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
    }
    
}
