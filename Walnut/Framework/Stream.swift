//
//  Stream.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

class Stream: Unique
{
    // MARK: - Variables
    var id = UUID()
    
    private var subscribers: Set<WrappedSubscriber>
    private var eventQueue: [Message]
    
    weak var parent: Stream?
    
    var identifier: Identifier
    
    var substreams: Set<Stream>
    
    var fullIdentifier: String
    {
        var i: String = ""
        
        if let parent = parent
        {
            i = parent.fullIdentifier
        }
        
        if i == ""
        {
            return identifier.value
        }
        else
        {
            return i + "." + identifier.value
        }
    }
    
    // MARK: - Initialization
    
    init(identifier: Identifier)
    {
        self.id = UUID()
        self.identifier = identifier
        self.eventQueue = []
        
        self.subscribers = []
        self.substreams = []
    }
    
    // MARK: - Functions
    
    func stream(with id: Identifier) -> Stream?
    {
        if id == identifier
        {
            return self
        }
        
        for stream in substreams
        {
            if let s = stream.stream(with: identifier)
            {
                return s
            }
        }
        
        return nil
    }
    
    /// Notify all of the subscribers about the event
    func send(message: Message)
    {
        message.timestamp = Date()
        
        for subscriber in subscribers
        {
            subscriber.receive(message: message)
        }
    }
    
    func printStreamTree()
    {
        print(fullIdentifier)
        
        for stream in substreams
        {
            stream.printStreamTree()
        }
    }
}

extension Stream
{
    func add(subscriber: WrappedSubscriber)
    {
        subscribers.insert(subscriber)
    }
    
    func remove(id: UUID)
    {
        subscribers = subscribers.filter({ subscriber in
            subscriber.id != id
        })
    }
}

extension Stream
{
    func add(substream: Stream)
    {
        substreams.insert(substream)
        substream.parent = self
    }
    
    func remove(substream: Stream)
    {
        substreams.remove(substream)
        substream.parent = nil
    }
}
