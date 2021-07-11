//
//  TableViewSection.swift
//  Walnut
//
//  Created by Joshua Grant on 7/10/21.
//

import Foundation

class TableViewSection
{
    var header: TableHeaderViewModel?
    var models: [TableViewCellModel]
    var footer: String?
    
    init(header: TableHeaderViewModel? = nil,
         models: [TableViewCellModel],
         footer: String? = nil)
    {
        self.header = header
        self.models = models
        self.footer = footer
    }
}
