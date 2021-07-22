//
//  EntityListRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit

class EntityListRouterContainer: Container
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
}

class EntityListRouter: Router<EntityListRouterContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: EntityListRouterContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }

    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    func routeToAdd(entityType: Entity.Type)
    {
        switch entityType
        {
        case is Stock.Type:
            let container = NewStockControllerContainer(context: container.context, stream: container.stream)
            let controller = container.makeController()
            let detailNavigation = UINavigationController(rootViewController: controller)
            detailNavigation.isModalInPresentation = true
            delegate?.navigationController?.present(detailNavigation, animated: true, completion: nil)
        case is System.Type:
            let builder = NewSystemControllerBuilder(context: container.context, stream: container.stream)
            let controller = builder.makeController()
            let navigation = UINavigationController(rootViewController: controller)
            navigation.isModalInPresentation = true
            delegate?.navigationController?.present(navigation, animated: true, completion: nil)
        default:
            let entity = entityType.init(context: container.context)
            entity.createdDate = Date()
            let detail = entity.detailController(context: container.context, stream: container.stream)
            delegate?.navigationController?.pushViewController(detail, animated: true)
            container.context.quickSave()
        }
    }
    
    func routeToDetail(entity: Entity)
    {
        let detail = entity.detailController(context: container.context, stream: container.stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
}

extension EntityListRouter: Subscriber
{
    func receive(message: Message)
    {
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
        routeToAdd(entityType: message.entityType)
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
