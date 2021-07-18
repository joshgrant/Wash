//
//  CurrentIdealController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

// TODO: Automatic "next" button updates when the data model changes...

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
            tableView = CurrentIdealStateTableView(newStockModel: newStockModel)
        }
        else
        {
            tableView = CurrentIdealNumericTableView(newStockModel: newStockModel)
        }
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
        
        let rightItem = UIBarButtonItem(systemItem: .done)
        rightItem.target = self
        rightItem.action = #selector(rightBarButtonItemDidTouchUpInside(_:))
        rightItem.isEnabled = newStockModel.validForCurrentIdeal
        
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
        minimumSource.value = newStockModel.minimum ?? 0
        stock.minimum = minimumSource
        
        let maximumSource = ValueSource(context: context)
        maximumSource.value = newStockModel.maximum ?? 100
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
        else if newStockModel.stockType == .percent
        {
            let amountSource = ValueSource(context: context)
            amountSource.value = newStockModel.currentDouble ?? 0
            stock.amount = amountSource
            
            let idealSource = ValueSource(context: context)
            idealSource.value = newStockModel.idealDouble ?? 100
            stock.ideal = idealSource
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
        case .currentState:
            // Open up the state picker view
            let detail = StatePickerController(newStockModel: newStockModel, isCurrent: true)
            navigationController?.pushViewController(detail, animated: true)
        case .idealState:
            // Open up the state picker view
            let detail = StatePickerController(newStockModel: newStockModel, isCurrent: false)
            navigationController?.pushViewController(detail, animated: true)
        case .statePicker:
            tableView.shouldReload = true
            navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForCurrentIdeal
        default:
            break
        }
    }
}
