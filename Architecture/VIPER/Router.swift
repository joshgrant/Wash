//
//  Router.swift
//  Architecture
//
//  Created by Joshua Grant on 6/24/21.
//

import Foundation
import UIKit

/**
 We need to expand our definition of "functional" programming. A pure function is any function that takes input
 and returns output that remains the same for the same input. A pure class is any class that takes function
 calls and returns the same behavior for the same function calls.
 
 Essentially, our classes are I/O devices and we want them to do their job consistently.
 
 Also, we want to be able to test our classes. This means using dependency injection. But the dependencies
 that we inject shouldn't "change"! Yikes! We should inject dependencies that are simply needed, but not
 refrenced.
 */

typealias TransitionCompletion = () -> Void

/// A `Router`'s input is a source view controller and destination token; the output is the transition
protocol Router
{
    associatedtype Destination
    func transition(to: Destination, from: UIViewController, completion: TransitionCompletion?)
}

class ViewControllerRouter: Router
{
    enum Destination
    {
        case back
        case search
        case detail(entity: NSObject)
    }
    
    func transition(to: Destination, from: UIViewController, completion: TransitionCompletion?)
    {
        switch to
        {
        case .back:
            transitionBack(from: from, completion: completion)
        case .search:
            transitionToSearch(from: from,completion: completion)
        case .detail(let entity):
            transitionToDetail(from: from, with: entity, completion: completion)
        }
    }
    
    func transitionBack(from: UIViewController, completion: TransitionCompletion?)
    {
        from.dismiss(animated: false, completion: completion)
    }
    
    func transitionToSearch(from: UIViewController, completion: TransitionCompletion?)
    {
    }
    
    func transitionToDetail(from: UIViewController, with entity: NSObject, completion: TransitionCompletion?)
    {
        // TODO: How can we construct this properly?
        /*
         We have to create the destination controller here, that's fine
         But what about dependencies? Should we have a resource locator?
         Should we have a factory
         Should we have a wrapper?
         */
    }
}
