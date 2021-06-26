//
//  EntityListRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit

class EntityListRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case add(entityType: Entity.Type)
        case detail(entity: Entity)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    weak var context: Context?
    weak var root: NavigationController?
    
    // MARK: - Initialization
    
    init(context: Context?, root: NavigationController?)
    {
        self.context = context
        self.root = root
        subscribe(to: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .add(let entityType):
            transitionToAdd(
                with: entityType,
                completion: completion)
        case .detail(let entity):
            transitionToDetail(
                with: entity,
                completion: completion)
        }
    }
    
    // MARK: - Utility
    
    private func transitionToAdd(
        with entityType: Entity.Type,
        completion: (() -> Void)?)
    {
        guard
            let context = context,
            let root = root
        else
        {
            completion?()
            return
        }
        
        let entity = entityType.init(context: context)
        let detail = entity.detailController(navigationController: root)
        root.pushViewController(detail, animated: true)
        context.quickSave()
        
        completion?()
    }
    
    private func transitionToDetail(
        with entity: Entity,
        completion: (() -> Void)?)
    {
        guard let root = root else
        {
            assertionFailure("Failed to route to detail")
            return
        }
        
        let detail = entity.detailController(navigationController: root)
        root.pushViewController(detail, animated: true)
    }
    
    private func handleEntityListSelectedCellMessage(_ message: EntityListCellMessage)
    {
        guard let context = context else {
            assertionFailure("Failed to get the context")
            return
        }
        let entity = message.entityType.all(context: context)[message.indexPath.row]
        transitionToDetail(with: entity, completion: nil)
    }
}

extension EntityListRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let x as EntityListAddButtonMessage:
            transitionToAdd(with: x.entityType, completion: nil)
        case let x as EntityListCellMessage where x.action == .selected:
            handleEntityListSelectedCellMessage(x)
        default:
            break
        }
    }
}
