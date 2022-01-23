//
//  EntityListViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/22/22.
//

import Foundation
import Protyper

class EntityListViewController: ViewController
{
    var entityType: EntityType
    var context: Context
    
    var allEntities: [Named] {
        let all = entityType.managedObjectType.all(context: context)
        return all.compactMap { $0 as? Named }
    }
    
    init(entityType: EntityType, context: Context)
    {
        self.entityType = entityType
        self.context = context
        super.init(title: entityType.title, view: nil)
    }
    
    override func display()
    {
        for item in allEntities.enumerated()
        {
            let entity = item.element
            let offset = item.offset + 1
            let icon = entityType.icon
            print("\(offset). \(icon.text) \(entity.title)")
        }
    }
    
    override func handle(command: Command)
    {
        guard let command = TableSelectionCommand(command: command) else { return }
        guard let row = command.row else { return }
        let entity = allEntities[row - 1]
        let controller = detailViewController(for: entity)
        navigationController?.push(controller: controller)
    }
    
    private func detailViewController(for entity: Entity) -> ViewController
    {
        guard let entity = entity as? Named else { fatalError() }
        return EntityDetailViewController(entity: entity, configuration: Configuration.configuration(for: entity))
    }
}
