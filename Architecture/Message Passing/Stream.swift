//
//  Stream.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation

// Streams can be split up into smaller streams - so subscribers
// can decide what they want to listen to

// A stream is like a notificaton center

// A stream can have its own thread - as long as subscribers
// are listening properly

// A substream is just an additional identifier. So if the main
// stream is "all", a substream could be "ui", so the identifier would end up being "all.ui" and we could pass messages to "all.ui"

// The main stream "all/main" would forward messages sent from publishers to the substreams that match. So essentially all a publisher needs to know is the main stream

class Stream
{
    // MARK: - Variables
    private var id: UUID
    private var subscribers: Set<WrappedSubscriber>
    private var eventQueue: [Event]
    
    weak var parent: Stream?
    
    var identifier: String
    
    var substreams: Set<Stream>
    
    var fullIdentifier: String
    {
        var i: String = ""
        
        if let parent = parent
        {
            i = parent.fullIdentifier
        }
        
        return i + identifier
    }
    
    // MARK: - Initialization
    
    init(identifier: String)
    {
        self.id = UUID()
        self.identifier = identifier
        self.eventQueue = []
        
        self.subscribers = []
        self.substreams = []
    }
    
    // MARK: - Functions
    
    func stream(with identifier: String) -> Stream?
    {
        if identifier == self.identifier
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
    func send(event: Event)
    {
        event.timestamp = Date()
        
        for subscriber in subscribers
        {
            subscriber.receive(event: event)
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

extension Stream: Hashable
{
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: Stream, rhs: Stream) -> Bool
    {
        lhs.id == rhs.id
    }
}

extension Stream
{
    func add(subscriber: WrappedSubscriber)
    {
        subscribers.insert(subscriber)
    }
    
    func remove(subscriber: WrappedSubscriber)
    {
        subscribers.remove(subscriber)
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
