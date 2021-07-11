//
//  LibraryTableViewRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class LibraryTableViewRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case detail(entityType: Entity.Type)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    weak var delegate: RouterDelegate?
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
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
            context: context)
        delegate?.navigationController?.pushViewController(listController, animated: true)
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
