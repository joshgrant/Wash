//
//  TableViewSelectionMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

// TODO: Not loving the tokens.
enum Token
{
    case stockDetail
    case valueTypeDetail
    case transferFlowDetail
    case linkSearch
}

class TableViewSelectionMessage: Message
{
    // MARK: - Variables
    
    var tableView: UITableView
    var indexPath: IndexPath
    var token: Token
    
    // MARK: - Initialization
    
    init(tableView: UITableView, indexPath: IndexPath, token: Token)
    {
        self.tableView = tableView
        self.indexPath = indexPath
        self.token = token
    }
}
