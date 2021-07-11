//
//  ToggleCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

// TODO: could refactor this into a selection identifier message...

class ToggleCellMessage: Message
{
    // MARK: - Variables
    
    var state: Bool
    var selectionIdentifier: SelectionIdentifier
    
    // MARK: - Initialization
    
    init(state: Bool, selectionIdentifier: SelectionIdentifier)
    {
        self.state = state
        self.selectionIdentifier = selectionIdentifier
    }
}
