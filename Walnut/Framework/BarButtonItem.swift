//
//  BarButtonItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class BarButtonItem: UIBarButtonItem
{
    var actionClosure: ActionClosure // This is strongly retained here...
    
    init(image: UIImage?, style: UIBarButtonItem.Style, actionClosure: ActionClosure)
    {
        self.actionClosure = actionClosure
        
        super.init()
        
        self.image = image
        self.style = style
        self.target = actionClosure
        self.action = #selector(actionClosure.perform(sender:))
    }
    
    init(title: String, actionClosure: ActionClosure)
    {
        self.actionClosure = actionClosure
        
        super.init()
        
        self.title = title
        self.target = actionClosure
        self.action = #selector(actionClosure.perform(sender:))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
