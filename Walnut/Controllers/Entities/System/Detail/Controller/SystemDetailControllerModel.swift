//
//  SystemDetailControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class SystemDetailControllerModel: ControllerModel
{
    // Info
    // Stocks
    // Flows
    // Events
    // Subsystems (what does this even imply?) // subsystems must serve the goal of the parent system
    // Notes
    
    // MARK: - Variables
    
    var system: System
    
    var title: String
    {
        system.title
    }
    
    // MARK: - Initialization
    
    required init(system: System)
    {
        self.system = system
    }
}
