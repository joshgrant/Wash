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
        
        title = "New Stock".localized
        
        view.embed(tableView)
        
        let leftItem = UIBarButtonItem(systemItem: .cancel)
        leftItem.target = self
        leftItem.action = #selector(leftBarButtonItemDidTouchUpInside(_:))
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemDidTouchUpInside(_:)))
        navigationItem.rightBarButtonItem = rightItem
        // TODO: Validate the right item...
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - View lifecycle
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: Interface outlets
    
    @objc func leftBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        router.route(to: .dismiss, completion: nil)
    }
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        router.route(to: .next, completion: nil)
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
        case let m as ToggleCellMessage:
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
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
            tableView.endUpdates()
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
    
    private func handle(_ message: ToggleCellMessage)
    {
        guard case .stateMachine = message.selectionIdentifier else { return }
        newStockModel.isStateMachine = message.state
        
        if newStockModel.isStateMachine
        {
            if newStockModel.stockType == .boolean
            {
                newStockModel.stockType = .decimal
            }
        }
        else if newStockModel.previouslyBoolean
        {
            newStockModel.stockType = .boolean
        }
        
        tableView.shouldReload = true
    }
}
