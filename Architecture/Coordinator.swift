//
//  Coordinator.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation
import UIKit

/// I'm not sure if I want to use a coordinator, or just a router. Which one is better?
/// A router knows, given the current view controller, what to present next
/// A coordinator knows, regardless of context, what to present, AND also
/// how to present the next thing in a flow. Too much responsibility?
class Coordinator<R: Router>
{
    // MARK: - Variables
    /// We maintain a strong reference because the coordinator contains all of the controllers
    var root: UINavigationController
    var router: R
    
    // MARK: - Initialization
    
    init(router: R)
    {
        self.root = UINavigationController()
        self.router = router
    }
    
    // MARK: - Functions
    
    /// Starting a coordinator means deciding which screen to show
    /// In addition, we can tell a coordinator how to get to a certain screen,
    /// or whether we want to present a new coordinator...
    func start()
    {
        
    }
}
