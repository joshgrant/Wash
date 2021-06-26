//
//  SystemDetailPinnedMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation

class SystemDetailPinnedMessage: Message
{
    // MARK: - Variables
    
    var isPinned: Bool
    var system: System
    
    // MARK: - Initialization
    
    init(isPinned: Bool, system: System)
    {
        self.isPinned = isPinned
        self.system = system
    }
}
