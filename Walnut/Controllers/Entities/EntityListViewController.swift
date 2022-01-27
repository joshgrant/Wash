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
    var tableView: TableView
    
    var allEntities: [Named] {
        let all = entityType.managedObjectType.all(context: context)
        return all.compactMap { $0 as? Named }
    }
    
    init(entityType: EntityType, context: Context)
    {
        self.entityType = entityType
        self.context = context
        self.tableView = TableView()
        super.init(title: entityType.title, view: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func display()
    {
//        for item in allEntities.enumerated()
//        {
//            let entity = item.element
//            let offset = item.offset
//            let icon = entityType.icon
//            print("\(offset). \(icon.text) \(entity.title)")
//        }
        print(tableView.content)
    }
    
//    override func handle(command: Command)
//    {
//        guard let command = TableSelectionCommand(command: command) else { return }
//        guard let row = command.row else { return }
//        let entity = allEntities[row - 1]
//        let controller = detailViewController(for: entity)
//        navigationController?.push(controller: controller)
//    }
    
    private func detailViewController(for entity: Entity) -> ViewController
    {
        guard let entity = entity as? Named else { fatalError() }
        return EntityDetailViewController(entity: entity, configuration: EntityType.configuration(for: entity))
    }
}

extension EntityListViewController: TableViewDelegate
{
    func tableView(_ tableView: TableView, didSelectRowAt indexPath: Index)
    {
        let entity = allEntities[indexPath.row]
        let controller = detailViewController(for: entity)
        navigationController?.push(controller: controller)
    }
}

extension EntityListViewController: TableViewDataSource
{
    func tableView(_ tableView: TableView, numberOfRowsInSection section: Int) -> Int
    {
        allEntities.count
    }
    
    func tableView(_ tableView: TableView, cellForRowAt indexPath: Index) -> TableViewCell
    {
        let entity = allEntities[indexPath.row]
        let icon = entityType.icon.text
        let text = "\(indexPath.row). \(icon) \(entity.title)"
        return TableViewCell(contentView: nil, accessories: [.label(text: text)])
    }
}
