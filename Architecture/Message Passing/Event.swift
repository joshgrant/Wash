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
    
    var data: EventData
    
    // MARK: - Initialization
    
    init(data: EventData)
    {
        self.id = UUID()
        self.data = data
    }
}

extension Event: CustomStringConvertible
{
    var description: String
    {
        data.token.value
    }
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
