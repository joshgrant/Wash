//
//  NewStockController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

class NewStockController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var router: NewStockRouter
    var newStockModel: NewStockModel
    var tableView: NewStockTableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        
        let newStockModel = NewStockModel()
        self.newStockModel = newStockModel
        
        router = NewStockRouter(newStockModel: newStockModel, context: context)
        
        tableView = NewStockTableView(newStockModel: newStockModel)
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        
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
    
    deinit
    {
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
        if newStockModel.stockType == .boolean
        {
            // route to current/ideal state
            router.route(
                to: .currentIdealState,
                completion: nil)
        }
        else if newStockModel.isStateMachine
        {
            router.route(
                to: .states,
                completion: nil)
        }
        else if newStockModel.stockType == .percent
        {
            router.route(
                to: .currentIdealState,
                completion: nil)
        }
        else
        {
             // Route to min/max controller
            router.route(
                to: .minMax,
                completion: nil)
        }
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
        case let m as TextEditCellMessage:
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
            router.route(to: .unitSearch, completion: nil)
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
        router.route(to: .back, completion: nil)
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        guard case .newStockName = message.selectionIdentifier else { return }
        newStockModel.title = message.title
    }
}
