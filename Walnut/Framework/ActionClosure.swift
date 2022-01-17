//
//  ActionClosure.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public typealias ActionPerformClosure = ((_ sender: AnyObject) -> Void)

// How does the retain cycle work on this one?
// Looks like sender is getting retained...

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
        performClosure(sender)
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
