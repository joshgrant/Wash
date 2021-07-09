//
//  ToggleCellMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class ToggleCellMessage: Message
{
    // MARK: - Variables
    
    var state: Bool
    
    // MARK: - Initialization
    
    init(state: Bool)
    {
        self.state = state
    }
}
