//
//  EntityListTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class EntityListTableViewDependencyContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var model: TableViewModel
    var stream: Stream
    var style: UITableView.Style
    var entityType: Entity.Type
    var context: Context
    
    // MARK: - Initialization
    
    init(model: TableViewModel, stream: Stream, style: UITableView.Style, entityType: Entity.Type, context: Context)
    {
        self.model = model
        self.stream = stream
        self.style = style
        self.entityType = entityType
        self.context = context
    }
}

class EntityListTableView: TableView<EntityListTableViewDependencyContainer>
{
    // MARK: - Initialization

    required init(container: EntityListTableViewDependencyContainer)
    {
        super.init(container: container)
        configure()
    }
    
    // MARK: - Configuration
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let actions = [
            makePinAction(forRowAt: indexPath),
            makeDeleteAction(forRowAt: indexPath, in: tableView)
        ].compactMap { $0 }
        
        return .init(actions: actions)
    }
}

// MARK: - Trailing swipe actions

extension EntityListTableView
{
    func makePinAction(forRowAt indexPath: IndexPath) -> UIContextualAction?
    {
        let entity = container.entityType.all(context: container.context)[indexPath.row]
        let title = entity.isPinned
            ? "Unpin".localized
            : "Pin".localized
        
        return .init(style: .normal, title: title) { [unowned self] action, view, completion in
            let message = EntityListPinMessage(entity: entity)
            self.container.stream.send(message: message)
            completion(true)
        }
    }
    
    func makeDeleteAction(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UIContextualAction?
    {
        let entity = container.entityType.all(context: container.context)[indexPath.row]
        let title = "Delete".localized
        
        return .init(style: .destructive, title: title) { [unowned self] action, view, completion in
            let message = EntityListDeleteMessage(entity: entity, indexPath: indexPath)
            self.container.stream.send(message: message)
            completion(true)
        }
    }
}
