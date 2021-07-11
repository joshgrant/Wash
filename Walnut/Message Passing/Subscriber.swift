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

protocol Subscriber: AnyObject, Unique
{
    func receive(message: Message)
}

extension Subscriber
{
    func makeSubscription() -> WrappedSubscriber
    {
        WrappedSubscriber(id: id) { [weak self] message in
            DispatchQueue.main.async {
                self?.receive(message: message)
            }
        }
    }
    
    func subscribe(to stream: Stream)
    {
        stream.add(subscriber: makeSubscription())
    }
    
    func unsubscribe(from stream: Stream)
    {
        stream.remove(id: id)
    }
}
