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
        let all = entityType.managedObjectType.all(context: context).sorted(by: {
            guard let first = $0.createdDate, let second = $1.createdDate else { return true }
            return first > second
        })
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
            tableView.handle(command: command)
        }
    }
    
    private func detailViewController(for entity: Named) -> ViewController
    {
        return EntityDetailViewController(
            entity: entity,
            configuration: EntityType.configuration(for: entity))
    }
    
    private func entity(at indexPath: Index) -> Named
    {
        return allEntities[indexPath.row]
    }
}

extension EntityListViewController: TableViewDelegate
{
    func tableView(_ tableView: TableView, didSelectRowAt indexPath: Index)
    {
        let entity = entity(at: indexPath)
        let controller = detailViewController(for: entity)
        navigationController?.push(controller: controller)
    }
    
    func tableView(_ tableView: TableView, performAction action: String, forRowAtIndexPath indexPath: Index)
    {
        let entity = entity(at: indexPath)
        
        switch action {
        case "delete":
            context.delete(entity)
        default:
            break
        }
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
