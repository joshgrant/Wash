//
//  Router.swift
//  Walnut
//
//  Created by Joshua Grant on 6/24/21.
//

import Foundation
import UIKit

typealias TransitionCompletion = () -> Void

protocol Router
{
    associatedtype Destination
    func transition(to: Destination, from: UIViewController, completion: TransitionCompletion?)
}
