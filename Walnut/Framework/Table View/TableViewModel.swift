//
//  TableViewData.swift
//  Walnut
//
//  Created by Joshua Grant on 7/10/21.
//

import Foundation

class TableViewModel
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
    
    // TODO: This is a hack...
    func sectionsUpdated()
    {
        models = sections.map { $0.models }
        headers = sections.map { $0.header }
        footers = sections.map { $0.footer }
    }
}
