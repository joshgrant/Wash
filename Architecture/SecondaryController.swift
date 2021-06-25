//
//  SecondaryController.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation
import UIKit

class SecondaryController: UIViewController
{
    init()
    {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
