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

public class Router<Container>
{
    // MARK: - Variables
    
    var container: Container
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    required init(container: Container)
    {
        self.container = container
    }
}
