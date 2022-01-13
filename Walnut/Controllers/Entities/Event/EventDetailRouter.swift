//
//  EventDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import Foundation

class EventDetailRouter
{
    // Route to condition info
    // Route to condition detail
    // Route to entity detail (flow)
    // Route to history (^)
    
    // MARK: - Variables
    
    var stream: Stream
    var context: Context
    
    // MARK: - Initialization
    
    init(stream: Stream, context: Context)
    {
        self.stream = stream
        self.context = context
    }
}
