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
        // FIXME: Use messages
        
        guard let context = context else { return nil }
        
        let entities = entityType.all(context: context)
        let entity = entities[indexPath.row]
        let isPinned = entity.isPinned
        let title = isPinned ? "Unpin".localized : "Pin".localized
        let pinAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            completion(true)
        }
        return pinAction
    }
    
    func makeDeleteAction(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UIContextualAction?
    {
        // FIXME: Use messages
        
        let title = "Delete".localized
        
        return .init(style: .destructive, title: title) { action, view, completion in
            guard let context = self.context else
            {
                completion(false);
                return
            }
            
            context.perform
            {
                let object = self.entityType.all(context: context)[indexPath.row]
                context.delete(object)
                context.quickSave()
                
                self.model = self.makeModel()
                
                DispatchQueue.main.async
                {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
            
            completion(true)
        }
    }
}
