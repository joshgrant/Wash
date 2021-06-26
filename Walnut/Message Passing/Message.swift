//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

class Message: Unique
{
    // MARK: - Variables
    
    var id = UUID()
    
    /// The `timestamp` is nil until the event is sent
    var timestamp: Date?
    
    // Message Data
    var token: MessageToken
    var info: [AnyHashable: Any]?
    
    // MARK: - Initialization
    
    init(token: MessageToken, info: [AnyHashable: Any]? = nil)
    {
        self.token = token
        self.info = info
    }
}

extension Message: CustomStringConvertible
{
    var description: String
    {
        token.value
    }
}
