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
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
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
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        guard let _ = message.tableView as? LibraryTableView else { return }
        
        switch message.cellModel.selectionIdentifier
        {
        case .entityType(let type):
            let managedType = type.managedObjectType
            route(to: .detail(entityType: managedType), completion: nil)
        default:
            break
        }
    }
}
