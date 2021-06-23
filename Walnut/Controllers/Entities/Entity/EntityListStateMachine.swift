//
//  EntityListStateMachine.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import ProgrammaticUI

enum EntityListState: String, Codable
{
    case unloaded
    case loading
    case loaded
    case appearing
    case disappearing
    case waiting
    case layingOutSubviews
}

class EntityListStateMachine: StateMachine<EntityListState>
{
    /// Needs to reload the data source and tableView
    var dirty: Bool = false
    
    // The managed object context for the current frame
    weak var context: Context?
    
    // The type?
    var type: Entity.Type?
}
