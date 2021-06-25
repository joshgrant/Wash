//
//  EntityListRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListRouter: AnyRouter
{
    // MARK: - Defined types
    
    enum Destination
    {
        case add(entityType: Entity.Type)
        case detail(entity: Entity)
    }
    
    // MARK: - Variables
    
    weak var context: Context?
    weak var navigationController: NavigationController?
    
    // MARK: - Initialization
    
    init(context: Context, navigationController: NavigationController)
    {
        self.context = context
        self.navigationController = navigationController
        super.init()
    }
    
    // MARK: - Functions
    
    func transition(to: Destination, from: UIViewController, completion: TransitionCompletion?)
    {
        switch to
        {
        case .add(let entityType):
            transitionToAdd(
                from: from,
                with: entityType,
                completion: completion)
        case .detail(let entity):
            transitionToDetail(
                from: from,
                with: entity,
                completion: completion)
        }
    }
    
    // MARK: - Utility
    
    private func transitionToAdd(
        from: UIViewController,
        with entityType: Entity.Type,
        completion: TransitionCompletion?)
    {
        guard
            let context = context,
            let navigationController = navigationController
        else
        {
            completion?()
            return
        }
        
        let entity = entityType.init(context: context)
        let detailController = entity.detailController(navigationController: navigationController)
        navigationController.pushViewController(detailController, animated: true)
        context.quickSave()
        
        completion?()
    }
    
    private func transitionToDetail(
        from: UIViewController,
        with entity: Entity,
        completion: TransitionCompletion?)
    {
        
    }
}
