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
    
    var newStockModel: NewStockModel
    var tableView: MinMaxTableView
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, context: Context?)
    {
        self.newStockModel = newStockModel
        tableView = MinMaxTableView(newStockModel: newStockModel)
        super.init(nibName: nil, bundle: nil)
        view.embed(tableView)
        
        let rightItem = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: self,
            action: #selector(nextButtonDidTouchUpInside(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func nextButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        // Route to current ideal
        let currentIdeal = CurrentIdealController(newStockModel: newStockModel, context: context)
        navigationController?.pushViewController(currentIdeal, animated: true)
    }
}
