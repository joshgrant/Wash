//
//  Heartbeat.swift
//  Command
//
//  Created by Joshua Grant on 3/19/22.
//

import Foundation

class Heartbeat
{
    // MARK: - Variables
    
    /// Return `false` to stop execution
    private var inputLoop: (Heartbeat) -> Void
    
    /// Return `false` to stop execution
    private var eventLoop: (Heartbeat) -> Void
    
    private lazy var inputThread: Thread = {
        let thread = Thread { [self] in
            while shouldRun
            {
                inputLoop(self)
            }
            print("Input terminated")
            
            eventTimer.invalidate()
            print("Event timer invalidated")
            
            print("Goodbye")
            exit(0)
        }
        return thread
    }()
    
    private lazy var eventTimer: Timer = {
        return Timer(timeInterval: 1.0, repeats: true) { [self] _ in
            eventLoop(self)
        }
    }()
    
    private var startTime: DispatchTime
    
    var shouldRun: Bool = true
    var tick: Int { DispatchTime.deltaSeconds(.now(), startTime) }
    
    // MARK: - Initialization
    
    @discardableResult
    init(inputLoop: @escaping (Heartbeat) -> Void,
         eventLoop: @escaping (Heartbeat) -> Void)
    {
        self.inputLoop = inputLoop
        self.eventLoop = eventLoop
        
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
