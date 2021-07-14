//
//  CurrentDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

class CurrentDetailController: UIViewController
{
    // MARK: - Variables
    
    var stock: Stock
    var tableView: CurrentDetailTableView
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        self.tableView = CurrentDetailTableView(stock: stock)
        super.init(nibName: nil, bundle: nil)
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
