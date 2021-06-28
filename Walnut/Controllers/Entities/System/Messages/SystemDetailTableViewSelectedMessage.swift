//
//  SystemDetailTableViewSelectedMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class SystemDetailTableViewSelectedMessage: Message
{
    // MARK: - Variables
    
    var tableView: UITableView
    var indexPath: IndexPath
    
    // MARK: - Initialization
    
    init(tableView: UITableView, indexPath: IndexPath)
    {
        self.tableView = tableView
        self.indexPath = indexPath
    }
}
