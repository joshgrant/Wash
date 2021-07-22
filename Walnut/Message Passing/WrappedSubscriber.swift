//
//  WrappedSubscriber.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

class WrappedSubscriber: Unique
{
    // MARK: - Variables
    
    var id = UUID()

    let closure: (Message) -> Void
    
    init(id: UUID, closure: @escaping (Message) -> Void)
    {
        self.id = id
        self.closure = closure
    }
    
    // MARK: - Functions
    
    func receive(message: Message)
    {
        closure(message)
    }
}
