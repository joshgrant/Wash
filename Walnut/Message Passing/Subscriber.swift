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

protocol Subscriber: Unique
{
    func receive(message: Message)
}

extension Subscriber
{
    func makeSubscription() -> WrappedSubscriber
    {
        WrappedSubscriber { message in
            self.receive(message: message)
        }
    }
    
    func subscribe(to stream: Stream)
    {
        let wrappedSubscriber = self.makeSubscription()
        stream.add(subscriber: wrappedSubscriber)
    }
}
