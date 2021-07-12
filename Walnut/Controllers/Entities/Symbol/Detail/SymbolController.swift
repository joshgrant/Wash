//
//  SymbolController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class SymbolController: UIViewController
{
    // MARK: - Variables
    
    var symbol: Symbol
    var tableView: SymbolTableView
    
    // MARK: - Initialization
    
    init(symbol: Symbol)
    {
        self.symbol = symbol
        self.tableView = SymbolTableView(symbol: symbol)
        super.init(nibName: nil, bundle: nil)
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
