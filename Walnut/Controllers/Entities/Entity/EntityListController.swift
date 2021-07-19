//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit

class EntityListController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var type: Entity.Type
    
    weak var context: Context?
    
    var router: EntityListRouter
    
    // Move these out of here?
    
    var tableView: EntityListTableView
    
    var addButtonImage: UIImage? { Icon.add.getImage() }
    var addButtonStyle: UIBarButtonItem.Style { .plain }
    
    // MARK: - Initialization
    
    init(
        type: Entity.Type,
        context: Context?)
    {
        self.type = type
        self.context = context
        self.tableView = EntityListTableView(entityType: type, context: context)
        self.router = .init(context: context)
        
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        self.title = type.readableName.pluralize()
        
        navigationItem.rightBarButtonItem = makeBarButtonItem()
        navigationItem.searchController = makeSearchController(searchControllerDelegate: self)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Factory
    
    func makeBarButtonItem() -> BarButtonItem
    {
        let actionClosure = ActionClosure { [unowned self] sender in
            let message = EntityListAddButtonMessage.init(sender: sender, entityType: self.type)
            AppDelegate.shared.mainStream.send(message: message)
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
        case is EntityListAddButtonMessage:
            fallthrough
        case is TextEditCellMessage:
            tableView.shouldReload = true
        case let m as EntityListPinMessage:
            handle(m)
        case let m as EntityListDeleteMessage:
            handle(m)
        case is CancelCreationMessage:
            tableView.shouldReload = true
        case is EntityInsertionMessage:
            tableView.shouldReload = true
        default:
            break
        }
    }
    
    private func handle(_ message: EntityListPinMessage)
    {
        // Do nothing
    }
    
    private func handle(_ message: EntityListDeleteMessage)
    {
        guard let context = context else { return }
        
        context.perform { [weak self] in
            let object = message.entity
            context.delete(object)
            context.quickSave()
            
            guard let self = self else { return }
            
            self.tableView.model = self.tableView.makeModel()
            
            DispatchQueue.main.async
            {
                // TODO: This is happening when the table view isn't in the window...
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [message.indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
}
