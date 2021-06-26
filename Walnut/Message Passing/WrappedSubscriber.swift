//
//  WrappedSubscriber.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct WrappedSubscriber: Unique
{
    // MARK: - Variables

    var id = UUID()
    let closure: (Message) -> Void
    
    // MARK: - Functions
    
    func receive(message: Message)
    {
        closure(message)
    }
}
