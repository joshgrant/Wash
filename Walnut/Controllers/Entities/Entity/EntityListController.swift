//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit

protocol EntityListFactory: Factory
{
    func makeTableView() -> EntityListTableView
    func makeModel() -> TableViewModel
    func makeMainSection() -> TableViewSection
    func makeRouter() -> EntityListRouter
}

class EntityListDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    var context: Context
    var stream: Stream
    
    lazy var router: EntityListRouter = makeRouter()
    
    lazy var tableView: EntityListTableView = makeTableView()
    
    // MARK: - Initialization
    
    init(entityType: Entity.Type, context: Context, stream: Stream)
    {
        self.entityType = entityType
        self.context = context
        self.stream = stream
    }
}

extension EntityListDependencyContainer: EntityListFactory
{
    func makeTableView() -> EntityListTableView
    {
        let model = makeModel()
        
        let container = EntityListTableViewDependencyContainer(
            model: model,
            stream: stream,
            style: .grouped,
            entityType: entityType,
            context: context)
        return EntityListTableView(container: container)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [makeMainSection()])
    }
    
    func makeMainSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = entityType
            .all(context: context)
            .compactMap { entity in
                guard let entity = entity as? Named else { return nil }
                return TextCellModel(
                    selectionIdentifier: .entity(entity: entity),
                    title: entity.title,
                    disclosureIndicator: true)
            }
        
        return TableViewSection(models: models)
    }
    
    func makeRouter() -> EntityListRouter
    {
        let container = EntityListRouterContainer(
            context: context,
            stream: stream)
        return EntityListRouter(container: container)
    }
}

class EntityListController: ViewController<EntityListDependencyContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()

    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    required init(container: EntityListDependencyContainer)
    {
        super.init(container: container)
        container.router.delegate = self
        subscribe(to: container.stream)
        configureForDisplay()
    }

    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    private func configureForDisplay()
    {
        self.title = container.entityType.readableName.pluralize()
        
        navigationItem.rightBarButtonItem = makeBarButtonItem()
        navigationItem.searchController = makeSearchController(searchControllerDelegate: self)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        view.embed(container.tableView)
    }
    
    // MARK: - Factory
    
    func makeBarButtonItem() -> BarButtonItem
    {
        let actionClosure = ActionClosure { [unowned self] sender in
            let message = EntityListAddButtonMessage.init(sender: sender, entityType: self.container.entityType)
            self.container.stream.send(message: message)
        }
        
        return BarButtonItem(
            image: Icon.add.getImage(),
            style: .plain,
            actionClosure: actionClosure)
    }
    
    func makeSearchController(searchControllerDelegate: UISearchControllerDelegate) -> UISearchController
    {
        // TODO: Make a better results controller
        let searchResultsController = UIViewController()
        searchResultsController.view.backgroundColor = .green
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = searchControllerDelegate
        return searchController
    }
}

extension EntityListController: UISearchControllerDelegate
{
    
}

extension EntityListController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case is EntityListAddButtonMessage,
             is TextEditCellMessage,
             is CancelCreationMessage,
             is EntityInsertionMessage:
            container.tableView.shouldReload = true
        case let m as EntityListDeleteMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: EntityListDeleteMessage)
    {
        container.context.perform { [unowned self] in
            let object = message.entity
            self.container.context.delete(object)
            self.container.context.quickSave()
            
            DispatchQueue.main.async
            {
                self.container.tableView.reload(shouldReloadTableView: false)
                self.container.tableView.beginUpdates()
                self.container.tableView.deleteRows(at: [message.indexPath], with: .automatic)
                self.container.tableView.endUpdates()
            }
        }
    }
}
