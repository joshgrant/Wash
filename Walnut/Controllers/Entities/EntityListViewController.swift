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
        super.init(title: entityType.title)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func loadView()
    {
        view = tableView
    }
    
    override func handle(command: Command)
    {
        switch command.rawString
        {
        case "add", "+":
            let new = NewEntityViewController(entityType: entityType, context: context)
            let nav = NavigationController(root: new)
            present(controller: nav)
        default:
            super.handle(command: command)
        }
    }
    
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
        return TableViewCell(components: [.label(text: text)])
    }
}
