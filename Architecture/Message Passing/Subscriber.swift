//
//  Subscriber.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

// A subscriber is the thing with side-effects
// It performs some work
// A subscriber can publish an event when it's done with its work

protocol Subscriber: Hashable
{
    var id: UUID { get }
    func receive(event: Event)
}

extension Subscriber
{
    func makeSubscription() -> WrappedSubscriber
    {
        return WrappedSubscriber { event in
            self.receive(event: event)
        }
    }
    
    func subscribe(to stream: Stream)
    {
        let wrappedSubscriber = self.makeSubscription()
        stream.add(subscriber: wrappedSubscriber)
    }
}

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
