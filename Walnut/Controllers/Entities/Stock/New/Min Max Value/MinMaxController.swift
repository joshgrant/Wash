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
        switch message.editType
        {
        case .beginEdit:
            navigationItem.rightBarButtonItem?.isEnabled = false
        case .dismiss:
            navigationItem.rightBarButtonItem?.isEnabled = newStockModel.validForMinMax
        default:
            break
        }
    }
}
