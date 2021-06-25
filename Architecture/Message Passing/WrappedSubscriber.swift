//
//  WrappedSubscriber.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

struct WrappedSubscriber
{
    // MARK: - Variables
    
    private let id = UUID()
    
    let closure: (Event) -> Void
    
    // MARK: - Functions
    
    func receive(event: Event)
    {
        closure(event)
    }
}

extension WrappedSubscriber: Hashable
{
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: WrappedSubscriber, rhs: WrappedSubscriber) -> Bool
    {
        lhs.id == rhs.id
    }
}
