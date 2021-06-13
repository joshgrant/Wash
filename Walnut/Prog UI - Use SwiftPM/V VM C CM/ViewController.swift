//
//  ViewController.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class ViewController<
    CM: ControllerModel,
    VM: ViewModel,
    V: View<VM>>: UIViewController
{
    // MARK: - Variables
    
    public var actionClosures: Set<ActionClosure> = []
    
    /// I have to add the underscore to not conflict with the default view from the view controller
    /// Maybe this isn't necessary - but the UIView isn't able to be genericized
    public var _view: V
    public var model: CM
    
    // MARK: - Initialization
    
    required public init(controllerModel: CM, viewModel: VM)
    {
        model = controllerModel
        _view = V(model: viewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        view = _view
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
