//
//  EntityListControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListControllerModel: ControllerModel
{
    // MARK: - Variables
    
    private var type: Entity.Type
    var title: String { type.readableName.pluralize() }
    
    // MARK: - Initialization
    
    init(type: Entity.Type)
    {
        self.type = type
    }
}
