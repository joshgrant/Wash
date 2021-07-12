//
//  DimensionController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class DimensionController: UIViewController
{
    // MARK: - Variables
    
    var dimension: Dimension
    var tableView: DimensionTableView
    
    // MARK: - Initialization
    
    init(dimension: Dimension)
    {
        self.dimension = dimension
        self.tableView = DimensionTableView(dimension: dimension)
        super.init(nibName: nil, bundle: nil)
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
