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
    
    var newStockModel: NewStockModel
    var tableView: NewStockTableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        
        let newStockModel = NewStockModel()
        self.newStockModel = newStockModel
        
        tableView = NewStockTableView(newStockModel: newStockModel)
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        view.endEditing(true)
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
        case let m as LinkSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .newStockUnit:
            routeToUnitSearch()
        case .valueType(let type):
            newStockModel.stockType = type
            tableView.reload(shouldReloadTableView: false)
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        default:
            break
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard case .newStock = message.origin else { return }
        guard let unit = message.link as? Unit else { fatalError() }
        newStockModel.unit = unit
        tableView.shouldReload = true
        navigationController?.popViewController(animated: true)
    }
}
