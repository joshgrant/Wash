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
        WrappedSubscriber { event in
            self.receive(event: event)
        }
    }
    
    func subscribe(to stream: Stream)
    {
        let wrappedSubscriber = self.makeSubscription()
        stream.add(subscriber: wrappedSubscriber)
    }
}

extension Subscriber
{
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool
    {
        lhs.id == rhs.id
    }
}
