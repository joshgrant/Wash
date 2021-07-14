//
//  StockValueTypeController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class StockValueTypeController: UIViewController
{
    // MARK: - Variables
    
    var stock: Stock
    var tableView: StockTypeTableView
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        tableView = StockTypeTableView(stock: stock)
        
        super.init(nibName: nil, bundle: nil)
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
