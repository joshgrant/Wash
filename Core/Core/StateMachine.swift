//
//  StateMachine.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

open class StateMachine<State>: Codable where State: Hashable & Codable
{
    // MARK: - Defined types
    
    public enum CodingKeys: CodingKey
    {
        case current
    }
    
    // MARK: - Variables
    
    open var current: State
    
    private(set) var stateQueue: [State]
    private(set) var operationQueue: OperationQueue
    
    // MARK: - Initialization
    
    public init(current: State)
    {
        self.current = current
        
        stateQueue = [current]
        operationQueue = OperationQueue()
        registerForNotifications()
        processStateQueue()
    }
    
    // MARK: - Coding
    
    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        current = try container.decode(State.self, forKey: .current)
        stateQueue = [current]
        operationQueue = OperationQueue()
        
        registerForNotifications()
        processStateQueue()
    }
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(current, forKey: .current)
    }
    
    // MARK: - Functions
    
    open func processStateQueue()
    {
        guard stateQueue.count > 0 else { return }
        
        let nextState = stateQueue.removeFirst()
        
        print("\(String(describing: self)): transitioned to: \(nextState)")
        transition(to: nextState)
        
        // Does this need to be performed on a separate thread?
        // Does this need to be synchronized with the main queue?
        if stateQueue.count > 0
        {
            operationQueue.addOperation {
                print("\(String(describing: self)): processing the state queue 2")
                self.processStateQueue()
            }
        }
    }
    
    open func canTransition(to: State) -> Bool
    {
        return true
    }
    
    open func transition(to nextState: State)
    {
        guard canTransition(to: nextState) else {
            DispatchQueue.main.async {
                print("\(String(describing: self)): failed state change to: \(nextState)")
                self.postStateChangeFailedNotification(failedState: nextState)
            }
            return
        }
        
        DispatchQueue.main.async {
            print("\(String(describing: self)): posting state change to: \(nextState)")
            self.postStateChangeNotification(state: nextState)
        }
        
        // If from background to foreground, we want to create the
        // window and the object memory graph
        // If from foreground to background, we want to save the database
        // Where should these be handled?
    }
    
    // MARK: - Notifications
    
    internal func registerForNotifications()
    {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(observeStateChangeRequest(_:)),
            name: .stateChangeRequest,
            object: nil)
    }
    
    @objc internal func observeStateChangeRequest(_ notification: Notification)
    {
        // TODO: Perhaps pass down other states here with a type switch...
        if let state = notification.userInfo?["state"] as? State
        {
            stateQueue.append(state)
            
            operationQueue.addOperation {
                print("\(String(describing: self)): processing the state queue 1")
                self.processStateQueue()
            }
        }
    }
    
    internal func postStateChangeNotification(state: State)
    {
        NotificationCenter.default.post(
            name: .stateChange,
            object: self,
            userInfo: ["state" : state])
    }
    
    internal func postStateChangeFailedNotification(failedState: State)
    {
        NotificationCenter.default.post(
            name: .stateChangeFailed,
            object: self,
            userInfo: ["currentState" : current,
                       "failedState" : failedState])
    }
}

public extension Notification.Name
{
    static let stateChangeRequest = Notification.Name("notification.stateChangeRequest")
    static let stateChangeFailed = Notification.Name("notification.stateChangeFailed")
    static let stateChange = Notification.Name("notification.stateChange")
}
