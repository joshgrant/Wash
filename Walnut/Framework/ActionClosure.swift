//
//  ActionClosure.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public typealias ActionPerformClosure = ((_ sender: AnyObject) -> Void)

// How does the retain cycle work on this one?

open class ActionClosure
{
    // MARK: - Variables
    
    var id: UUID = .init()
    public var performClosure: ActionPerformClosure
    
    // MARK: - Initialization
    
    public init(performClosure: @escaping ActionPerformClosure)
    {
        self.performClosure = performClosure
    }
    
    // MARK: - Functions
    
    @objc public func perform(sender: AnyObject)
    {
        // HMM, how to get the app state here?
        // Right now, when the bar button is selected, the action's return value will
        // be consumed by the action... but we need the resulting appState to be modified...
        // being passed to the main run loop...
        _ = performClosure(sender)
    }
}

// MARK: - Hashable

extension ActionClosure: Hashable
{
    public static func == (lhs: ActionClosure, rhs: ActionClosure) -> Bool
    {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}
