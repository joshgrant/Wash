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

class TableViewData
{
    var sections: [TableViewSection]
    var models: [[TableViewCellModel]]
    var headers: [TableHeaderViewModel?]
    var footers: [String?]
    
    init(sections: [TableViewSection])
    {
        self.sections = sections
        
        models = sections.map { $0.models }
        headers = sections.map { $0.header }
        footers = sections.map { $0.footer }
    }
    
    var cellModelTypes: [TableViewCellModel.Type]
    {
        models.flatMap { cellModels in
            cellModels.map { cellModel in
                type(of: cellModel)
            }
        }
    }
}

struct TableViewSectionType: Unique
{
    var id = UUID()
    var index: Int
    
    static let info = TableViewSectionType(index: 0)
    static let events = TableViewSectionType(index: 1)
    static let history = TableViewSectionType(index: 2)
    
}

class TableViewSection
{
    var type: TableViewSectionType
    var rows: [TableViewRow]
    
    var header: TableHeaderViewModel?
    var models: [TableViewCellModel]
    var footer: String?
    
    init(type: TableViewSectionType,
         header: TableHeaderViewModel? = nil,
         rows: [TableViewRow],
         footer: String? = nil)
    {
        self.type = type
        self.rows = rows
        
        self.header = header
        models = rows.map { $0.model }
        self.footer = footer
    }
}

struct TableViewRowType: Unique
{
    var id = UUID()
    
    var index: Int
    
    static let title = TableViewRowType(index: 0)
    static let from = TableViewRowType(index: 1)
    static let to = TableViewRowType(index: 2)
    static let amount = TableViewRowType(index: 3)
    static let duration = TableViewRowType(index: 4)
    static let requiresUserCompletion = TableViewRowType(index: 5)
    static let event = TableViewRowType(index: -1)
    static let history = TableViewRowType(index: -1)
}

class TableViewRow
{
    var type: TableViewRowType
    var model: TableViewCellModel
    
    init(type: TableViewRowType, model: TableViewCellModel)
    {
        self.type = type
        self.model = model
    }
}

class TableViewSelectionMessage: Message
{
    // MARK: - Variables
    
    var tableView: UITableView
    var indexPath: IndexPath
    var token: Token
    
    // MARK: - Initialization
    
    init(
        tableView: UITableView,
        indexPath: IndexPath,
        token: Token)
    {
        self.tableView = tableView
        self.indexPath = indexPath
        self.token = token
    }
}
