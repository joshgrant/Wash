//
//  SystemDetailDuplicatedMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation

class SystemDetailDuplicatedMessage: Message
{
    // MARK: - Variables
    
    var system: System
    
    // MARK: - Initialization
    
    init(system: System)
    {
        self.system = system
    }
}
