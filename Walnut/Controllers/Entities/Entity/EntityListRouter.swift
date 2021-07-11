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
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        subscribe(to: AppDelegate.shared.mainStream)
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .add(let entityType):
            routeToAdd(entityType: entityType)
        case .detail(let entity):
            routeToDetail(entity: entity)
        }
    }
    
    private func routeToAdd(entityType: Entity.Type)
    {
        guard let context = context else
        {
            return
        }
        
        print("WEIRD")
        
        let entity = entityType.init(context: context)
        entity.createdDate = Date()
        
        let detail = entity.detailController()
        delegate?.navigationController?.pushViewController(detail, animated: true)
        context.quickSave()
    }
    
    private func routeToDetail(entity: Entity)
    {
        let detail = entity.detailController()
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
}

extension EntityListRouter: Subscriber
{
    func receive(message: Message)
    {
        print(message)
        
        switch message
        {
        case let m as EntityListAddButtonMessage:
            handle(m)
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: EntityListAddButtonMessage)
    {
        route(to: .add(entityType: message.entityType), completion: nil)
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .entity(let entity):
            routeToDetail(entity: entity)
        default:
            break
        }
    }
}
