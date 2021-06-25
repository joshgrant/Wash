//
//  EventData.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct EventData
{
    /// A token is a unique string that identifies the data
    var token: String
    var info: [AnyHashable: Any]?
}
