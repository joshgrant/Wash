//
//  View.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class View<VM: AnyObject>: UIView
{
    public var model: VM
    
    public required init(model: VM)
    {
        self.model = model
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    public override init(frame: CGRect)
    {
        fatalError("Load this view programmatically")
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder)
    {
        fatalError("Load this view programmatically")
    }
}
