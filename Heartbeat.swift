//
//  Heartbeat.swift
//  Command
//
//  Created by Joshua Grant on 3/19/22.
//

import Foundation

class Heartbeat
{
    typealias Completion = () -> Void
    
    // MARK: - Variables
    
    private var inputLoop: (Heartbeat) -> Void
    private var eventLoop: (Heartbeat) -> Void
    private var cleanup: (Completion) -> Void
    
    private lazy var inputThread: Thread = {
        let thread = Thread { [self] in
            while !shouldQuit
            {
                inputLoop(self)
            }
            
            cleanup {
                print("Input terminated")
                
                eventTimer.invalidate()
                print("Event timer invalidated")
                
                print("Goodbye")
                exit(0)
            }
        }
        return thread
    }()
    
    private lazy var eventTimer: Timer = {
        return Timer(timeInterval: 1, repeats: true) { [self] _ in
            eventLoop(self)
        }
    }()
    
    private var startTime: DispatchTime
    
    var shouldQuit: Bool = false
    var tick: Int { DispatchTime.deltaSeconds(.now(), startTime) }
    
    // MARK: - Initialization
    
    @discardableResult
    init(inputLoop: @escaping (Heartbeat) -> Void,
         eventLoop: @escaping (Heartbeat) -> Void,
         cleanup: @escaping (Completion) -> Void)
    {
        self.inputLoop = inputLoop
        self.eventLoop = eventLoop
        self.cleanup = cleanup
        
        startTime = .now()

        configureInputThread()
        configureEventTimer()
    }
    
    // MARK: - Configuration
    
    private func configureInputThread()
    {
        inputThread.start()
    }
    
    private func configureEventTimer()
    {
        RunLoop.current.add(eventTimer, forMode: .common)
    }
}

extension DispatchTime
{
    static func deltaSeconds(_ a: DispatchTime, _ b: DispatchTime) -> Int
    {
        let delta = a.uptimeNanoseconds - b.uptimeNanoseconds
        return Int(delta / 1_000_000_000)
    }
}
