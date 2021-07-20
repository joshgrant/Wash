//
//  ViewController.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class ViewController<Container: DependencyContainer>: UIViewController
{
    // MARK: - Variables
    
    var container: Container
    
    // MARK: - Initialization
    
    public required init(container: Container)
    {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        fatalError("Load this view programmatically")
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder)
    {
        fatalError("Load this view programmatically")
    }
}
