//
//  Event.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

class Event
{
    // MARK: - Variables
    
    var id: UUID
    
    /// The `timestamp` is nil until the event is sent
    var timestamp: Date?
    
    // Event Data
    var token: EventToken
    var info: [AnyHashable: Any]?
    
    // MARK: - Initialization
    
    init(token: EventToken, info: [AnyHashable: Any]? = nil)
    {
        self.id = UUID()
        self.token = token
        self.info = info
    }
}

extension Event: CustomStringConvertible
{
    var description: String { token.value }
}

extension Event: Hashable
{
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool
    {
        lhs.id == rhs.id
    }
}
