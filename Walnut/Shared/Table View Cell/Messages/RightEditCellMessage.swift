//
//  RightEditCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

enum EditType
{
    case dismiss
    case edit
    case beginEdit
}

class RightEditCellMessage: Message
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var content: String
    var editType: EditType
    
    // MARK: - Initialization
    
    init(selectionIdentifier: SelectionIdentifier, content: String, editType: EditType)
    {
        self.selectionIdentifier = selectionIdentifier
        self.content = content
        self.editType = editType
    }
}
