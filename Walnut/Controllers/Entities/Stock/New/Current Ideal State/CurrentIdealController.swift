//
//  CurrentIdealController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class CurrentIdealController: UIViewController
{
    // If a state machine, each cell should be a
    // detail cell that opens up the link selector (for just the states)
    
    // If boolean, two sections, first is "Current", second
    // is "ideal" and each has two cells, with checkmarks
    // that lets us select true/false
    
    // If numeric, one section, two cells, each has a right
    // edit cell that uses the symbol of the unit
    // on the right (or percent) with numeric entry
    // If integer, don't allow decimal places
    
    // Also, text field has an ∞ sign
    
    // MARK: - Variables
    
    var id = UUID()
    
    var newStockModel: NewStockModel
    var tableView: TableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, context: Context?)
    {
        self.newStockModel = newStockModel
        self.context = context
        
        if newStockModel.stockType == .boolean
        {
            tableView = CurrentIdealBooleanTableView(newStockModel: newStockModel)
        }
        else if newStockModel.isStateMachine
        {
            tableView = CurrentIdealStateTableView()
        }
        else
        {
            tableView = CurrentIdealNumericTableView()
        }
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
        
        let rightItem = UIBarButtonItem(systemItem: .done)
        rightItem.target = self
        rightItem.action = #selector(rightBarButtonItemDidTouchUpInside(_:))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        // Save!
        guard let context = context else { fatalError() }
        
        let stock = Stock(context: context)
        
        let title = Symbol(context: context)
        title.name = newStockModel.title
        stock.symbolName = title
        
        stock.unit = newStockModel.unit
        stock.valueType = newStockModel.stockType
        stock.stateMachine = newStockModel.isStateMachine
        
        let minimumSource = ValueSource(context: context)
        minimumSource.value = newStockModel.minimum
        stock.minimum = minimumSource
        
        let maximumSource = ValueSource(context: context)
        maximumSource.value = newStockModel.maximum
        stock.maximum = maximumSource
        
        if newStockModel.stockType == .boolean
        {
            let amountSource = BooleanSource(context: context)
            amountSource.value = newStockModel.currentBool ?? true
            stock.amount = amountSource
            
            let idealSource = BooleanSource(context: context)
            idealSource.value = newStockModel.idealBool ?? true
            stock.ideal = idealSource
        }
        else
        {
            fatalError()
        }
        
        context.quickSave()
    }
}

extension CurrentIdealController: Subscriber
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
        switch message.cellModel.selectionIdentifier
        {
        case .currentBool(let state):
            newStockModel.currentBool = state
            tableView.reload(shouldReloadTableView: false)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        case .idealBool(let state):
            newStockModel.idealBool = state
            tableView.reload(shouldReloadTableView: false)
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        default:
            break
        }
    }
}
