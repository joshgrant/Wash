//
//  Router.swift
//  Walnut
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation
import UIKit

public protocol RouterDelegate: AnyObject
{
    var navigationController: UINavigationController? { get }
}

public protocol Router
{
    associatedtype Destination
    
    var delegate: RouterDelegate? { get set }
    
    func route(to destination: Destination, completion: (() -> Void)?)
}
