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
        switch entity
        {
        case let s as Stock:
            return StockDetailViewController(stock: s)
        case let f as Flow:
            return FlowDetailViewController(flow: f)
        case let t as Task:
            return TaskDetailViewController(task: t)
        case let e as Event:
            return EventDetailViewController(event: e)
        case let c as Conversion:
            return ConversionDetailViewController(conversion: c)
        case let c as Condition:
            return ConditionDetailViewController(condition: c)
        case let s as Symbol:
            return SymbolDetailViewController(symbol: s)
        case let n as Note:
            return NoteDetailViewController(note: n)
        case let u as Unit:
            return UnitDetailViewController(unit: u)
        default:
            fatalError("Unhandled entity")
        }
    }
}
