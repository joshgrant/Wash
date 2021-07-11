//
//  EntityListTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class EntityListTableView: TableView
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(entityType: Entity.Type, context: Context?)
    {
        self.entityType = entityType
        self.context = context
        
        super.init()
    }
    
    // MARK: - Configuration
    
    override func makeModel() -> TableViewModel
    {
        guard let context = context else
        {
            fatalError("Context is nil")
        }
        
        return TableViewModel(sections: [makeMainSection(
                                            context: context,
                                            entityType: entityType)])
    }
    
    func makeMainSection(context: Context, entityType: Entity.Type) -> TableViewSection
    {
        TableViewSection(models: makeEntityListCellModels(
                            context: context,
                            entityType: entityType))
    }
    
    func makeEntityListCellModels(context: Context, entityType: Entity.Type) -> [TableViewCellModel]
    {
        entityType
            .all(context: context)
            .compactMap { entity in
                guard let entity = entity as? Named else { return nil }
                return TextCellModel(
                    selectionIdentifier: .entity(entity: entity),
                    title: entity.title,
                    disclosureIndicator: true)
            }
    }
    
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
        guard let context = context else { return nil }
        
        let entity = entityType.all(context: context)[indexPath.row]
        let title = entity.isPinned
            ? "Unpin".localized
            : "Pin".localized
        
        return .init(style: .normal, title: title) { action, view, completion in
            let message = EntityListPinMessage(entity: entity)
            AppDelegate.shared.mainStream.send(message: message)
            completion(true)
        }
    }
    
    func makeDeleteAction(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UIContextualAction?
    {
        guard let context = self.context else {
            return nil
        }
        
        let entity = entityType.all(context: context)[indexPath.row]
        let title = "Delete".localized
        
        return .init(style: .destructive, title: title) { action, view, completion in

            let message = EntityListDeleteMessage(entity: entity, indexPath: indexPath)
            AppDelegate.shared.mainStream.send(message: message)
            completion(true)
        }
    }
}
