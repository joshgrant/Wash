//
//  NewStockController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

class NewStockController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var tableView: NewStockTableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        
        tableView = NewStockTableView()
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel)
        navigationItem.rightBarButtonItem = BarButtonItem(
            title: "Next".localized,
            actionClosure: ActionClosure { [weak self] sender in
                self?.routeToNext()
            })
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    func routeToNext()
    {
        print("Routing to next!")
    }
    
    func routeToUnitSearch()
    {
        let linkController = LinkSearchController(
            origin: .newStock,
            entityType: Unit.self,
            context: context,
            hasAddButton: true)
        navigationController?.pushViewController(linkController, animated: true)
    }
}

extension NewStockController: Subscriber
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
        guard case .newStockUnit = message.cellModel.selectionIdentifier else
        {
            return
        }
        
        routeToUnitSearch()
    }
}
