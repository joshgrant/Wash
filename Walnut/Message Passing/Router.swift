//
//  Router.swift
//  Walnut
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation
import UIKit

protocol Router
{
    associatedtype Destination
    
    var root: NavigationController? { get set }
    
    func route(to destination: Destination, completion: (() -> Void)?)
}
