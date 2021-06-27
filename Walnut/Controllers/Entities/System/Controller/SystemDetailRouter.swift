//
//  SystemDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation

class SystemDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        // If the entity is nil, we're trying to create one
        case idealInfo
        case stockDetail(stock: Stock?)
        case flowDetail(flow: TransferFlow?)
        case eventDetail(event: Event?)
        case subsystemDetail(system: System?)
        case noteDetail(note: Note?)
        
        case search(entityType: Entity.Type)
    }
    
    // MARK: - Variables
    
    var root: NavigationController?
    
    // MARK: - Functions
    
    func route(
        to destination: Destination,
        completion: (() -> Void)?)
    {
        print("IMPLEMENT ROUTING")
    }
}
