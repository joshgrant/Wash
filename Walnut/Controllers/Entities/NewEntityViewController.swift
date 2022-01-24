//
//  NewEntityViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/24/22.
//

import Foundation
import Protyper

class NewEntityViewController: ViewController
{
    var entityType: EntityType
    var context: Context
    
    init(entityType: EntityType, context: Context)
    {
        self.entityType = entityType
        self.context = context
    }
}
