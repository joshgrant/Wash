//
//  Heartbeat.swift
//  Command
//
//  Created by Joshua Grant on 3/19/22.
//

import Foundation

typealias Completion = () -> Void
typealias DispatchCompletion = (@escaping Completion) -> Void

class Heartbeat
{
    // MARK: - Variables
    
    @available(*, deprecated)
    var shouldQuit: Bool = false
    
    private var start: DispatchCompletion
    private var inputLoop: (Heartbeat) -> Void
    private var eventLoop: (Heartbeat) -> Void
    private var cleanup: DispatchCompletion
    
    private lazy var inputThread: Thread = {
        let thread = Thread { [self] in
            while !shouldQuit
            {
                inputLoop(self)
            }
            
            cleanup {
                DispatchQueue.main.async { [weak self] in
                    print("Input terminated")
                    
                    self?.eventTimer.invalidate()
                    print("Event timer invalidated")
                    
                    print("Goodbye")
                    exit(0)
                }
            }
        }
        return thread
    }()
    
    private lazy var eventTimer: Timer = {
        return Timer(timeInterval: 1, repeats: true) { [self] _ in
            eventLoop(self)
        }
    }()
    
    // MARK: - Initialization
    
    @discardableResult
    init(start: @escaping DispatchCompletion,
        inputLoop: @escaping (Heartbeat) -> Void,
         eventLoop: @escaping (Heartbeat) -> Void,
         cleanup: @escaping DispatchCompletion)
    {
        self.start = start
        self.inputLoop = inputLoop
        self.eventLoop = eventLoop
        self.cleanup = cleanup
    }
    
    // MARK: - Configuration
    
    func run()
    {
        start { [self] in
            configureInputThread()
            configureEventTimer()
        }
    }
    
    private func configureInputThread()
    {
        inputThread.start()
    }
    
    private func configureEventTimer()
    {
        RunLoop.current.add(eventTimer, forMode: .common)
    }
}
