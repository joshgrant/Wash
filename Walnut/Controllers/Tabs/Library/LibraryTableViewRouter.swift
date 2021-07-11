//
//  LibraryTableViewRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation

class LibraryTableViewRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case detail(entityType: Entity.Type)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    weak var root: UINavigationController?
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(root: UINavigationController?, context: Context?)
    {
        self.root = root
        self.context = context
        
        subscribe(to: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    func route(
        to destination: Destination,
        completion: (() -> Void)?)
    {
        switch destination
        {
        case .detail(let entityType):
            routeToDetail(entityType: entityType)
        }
    }
    
    private func routeToDetail(entityType: Entity.Type)
    {
        let listController = EntityListController(
            type: entityType,
            context: context,
            navigationController: root)
        root?.pushViewController(listController, animated: true)
    }
}

extension LibraryTableViewRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let x as LibraryCellSelectionMessage:
            handleSelection(message: x)
        default:
            break
        }
    }
    
    private func handleSelection(message: LibraryCellSelectionMessage)
    {
        let entityType = EntityType.libraryVisible[message.indexPath.row]
        let managedType = entityType.managedObjectType
        route(to: .detail(entityType: managedType), completion: nil)
    }
}
