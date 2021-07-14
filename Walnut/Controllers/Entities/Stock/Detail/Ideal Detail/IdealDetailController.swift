//
//  IdealDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

class IdealDetailController: UIViewController
{
    // MARK: - Variables
    
    var stock: Stock
    var tableView: IdealDetailTableView
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        self.tableView = IdealDetailTableView(stock: stock)
        super.init(nibName: nil, bundle: nil)
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
