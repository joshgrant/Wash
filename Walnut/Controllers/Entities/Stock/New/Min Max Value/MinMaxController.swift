//
//  MinMaxController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class MinMaxController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var newStockModel: NewStockModel
    var tableView: MinMaxTableView
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, context: Context?)
    {
        self.newStockModel = newStockModel
        self.context = context
        
        tableView = MinMaxTableView(newStockModel: newStockModel)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
        
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: self,
            action: #selector(nextButtonDidTouchUpInside(_:)))
        rightItem.isEnabled = newStockModel.validForMinMax
        
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
    
    @objc func nextButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        transferCellContentToModels()
        let currentIdeal = CurrentIdealController(newStockModel: newStockModel, context: context)
        navigationController?.pushViewController(currentIdeal, animated: true)
    }
    
    // FIXME: Also a hack
    func transferModelContentToCells()
    {
        let first = IndexPath(row: 0, section: 0)
        let firstCell = tableView.cellForRow(at: first) as! RightEditCell
        let second = IndexPath(row: 1, section: 0)
        let secondCell = tableView.cellForRow(at: second) as! RightEditCell
        
        var min: String
        var max: String
        
        if newStockModel.minimum == Double.infinity
        {
            min = "∞"
        }
        else if newStockModel.minimum == -Double.infinity
        {
            min = "-∞"
        }
        else if let minimum = newStockModel.minimum
        {
            min = String(format: "%i", Int(minimum))
        }
        else
        {
            min = ""
        }
        
        if newStockModel.maximum == Double.infinity
        {
            max = "∞"
        }
        else if newStockModel.maximum == -Double.infinity
        {
            max = "-∞"
        }
        else if let maximum = newStockModel.maximum
        {
            max = String(format: "%i", Int(maximum))
        }
        else
        {
            max = ""
        }
        
        firstCell.rightField.text = min
        secondCell.rightField.text = max
    }
    
    // FIXME: This is a hack
    func transferCellContentToModels()
    {
        let first = IndexPath(row: 0, section: 0)
        let firstCell = tableView.cellForRow(at: first) as! RightEditCell
        let second = IndexPath(row: 1, section: 0)
        let secondCell = tableView.cellForRow(at: second) as! RightEditCell
        
        newStockModel.minimum = Double(firstCell.rightField.text ?? "0")
        newStockModel.maximum = Double(secondCell.rightField.text ?? "0")
        
        // Constraints for the to-be ideal and current
        
        if let current = newStockModel.currentDouble
        {
            if current >= newStockModel.maximum!
            {
                newStockModel.currentDouble = newStockModel.maximum
            }
            else if current <= newStockModel.minimum!
            {
                newStockModel.currentDouble = newStockModel.minimum
            }
        }
        else
        {
            newStockModel.currentDouble = newStockModel.minimum!
        }
        
        if let ideal = newStockModel.idealDouble
        {
            if ideal >= newStockModel.maximum!
            {
                newStockModel.idealDouble = newStockModel.maximum
            }
            else if ideal <= newStockModel.minimum!
            {
                newStockModel.idealDouble = newStockModel.minimum
            }
        }
        else
        {
            newStockModel.idealDouble = newStockModel.minimum!
        }
    }
}

extension MinMaxController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as RightEditCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        var value: Double
        
        if message.content == "∞"
        {
            value = Double.infinity
        }
        else if message.content == "-∞"
        {
            value = -Double.infinity
        }
        else
        {
            // TODO: Disallow pasting text into the fields unless it's only numbers...
            value = Double(message.content) ?? 0
        }
        
        switch message.selectionIdentifier
        {
        case .minimum:
            if let max = newStockModel.maximum, value >= max
            {
                value = max
            }
            
            newStockModel.minimum = value
            // TODO: set the text on the text field...
        case .maximum:
            if let min = newStockModel.minimum, value <= min
            {
                value = min
            }
            
            newStockModel.maximum = value
            // TODO: Set the text on the text field...
        default:
            break
        }
        
        switch message.editType
        {
        case .beginEdit:
            navigationItem.rightBarButtonItem?.isEnabled = false
        case .dismiss:
            transferModelContentToCells()
            navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForMinMax
        default:
            break
        }
    }
}
