//
//  TableViewSection.swift
//  Walnut
//
//  Created by Joshua Grant on 7/10/21.
//

import Foundation

class TableViewSection
{
    var rows: [TableViewRow]
    
    var header: TableHeaderViewModel?
    var models: [TableViewCellModel]
    var footer: String?
    
    init(header: TableHeaderViewModel? = nil,
         rows: [TableViewRow],
         footer: String? = nil)
    {
        self.rows = rows
        
        self.header = header
        models = rows.map { $0.model }
        self.footer = footer
    }
}
