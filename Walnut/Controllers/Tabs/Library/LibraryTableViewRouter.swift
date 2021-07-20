//
//  LibraryTableViewRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class LibraryTableViewRouterContainer: DependencyContainer
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
}

class LibraryTableViewRouter: Router<LibraryTableViewRouterContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: LibraryTableViewRouterContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    func routeToDetail(entityType: Entity.Type)
    {
        let container = EntityListDependencyContainer(
            entityType: entityType,
            context: container.context,
            stream: container.stream)
        let listController = EntityListController(container: container)
        delegate?.navigationController?.pushViewController(listController, animated: true)
    }
}

extension LibraryTableViewRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        guard let _ = message.tableView as? TableView<LibraryTableViewContainer> else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .entityType(let type):
            let managedType = type.managedObjectType
            routeToDetail(entityType: managedType)
        default:
            break
        }
    }
}
