//
//  EntityListViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/22/22.
//

import Foundation
import Protyper
import CoreData

class EntityListViewController: ViewController
{
    var entityType: EntityType
    var context: Context
    var tableView: TableView
    
    lazy var fetchController: NSFetchedResultsController<NSFetchRequestResult> = {
        let request: NSFetchRequest<NSFetchRequestResult> = entityType.managedObjectType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Entity.createdDate, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    init(entityType: EntityType, context: Context)
    {
        self.entityType = entityType
        self.context = context
        self.tableView = TableView()
        super.init(title: entityType.title)
        tableView.delegate = self
        tableView.dataSource = self
        
        try? fetchController.performFetch()
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
        case "delete":
            let command = TableSelectionCommand(command: command)
            
            if let row = command?.row, let entity = fetchController.fetchedObjects?[row] as? Entity {
                context.delete(entity)
            }
        case "delete all":
            let allObjects = entityType.managedObjectType.all(context: context)
            for object in allObjects {
                context.delete(object)
            }
            context.quickSave()
        default:
            super.handle(command: command)
        }
    }
    
    private func detailViewController(for entity: Named) -> ViewController
    {
        return EntityDetailViewController(
            entity: entity,
            configuration: EntityType.configuration(for: entity))
    }
    
    private func entity(at indexPath: Index) -> Named?
    {
        guard let objects = fetchController.fetchedObjects else { return nil }
        guard objects.count > indexPath.row else { return nil }
        return objects[indexPath.row] as? Named
    }
}

extension EntityListViewController: TableViewDelegate
{
    func tableView(_ tableView: TableView, didSelectRowAt indexPath: Index)
    {
        guard let entity = entity(at: indexPath) else { return }
        let controller = detailViewController(for: entity)
        navigationController?.push(controller: controller)
    }
    
    func tableView(_ tableView: TableView, performAction action: String, forRowAtIndexPath indexPath: Index)
    {
        guard let entity = entity(at: indexPath) else { return }
        
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
        fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: TableView, cellForRowAt indexPath: Index) -> TableViewCell
    {
        guard let entity = entity(at: indexPath) else { fatalError() }
        let icon = entityType.icon.text
        let text = "\(indexPath.row). \(icon) \(entity.title)"
        return TableViewCell(components: [.label(text: text)])
    }
}

extension EntityListViewController: NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
    }
}
