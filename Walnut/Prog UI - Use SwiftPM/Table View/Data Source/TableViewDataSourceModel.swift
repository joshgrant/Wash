//
//  TableViewDataSourceModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public class TableViewDataSourceModel
{
    // MARK: - Variables
    
    var cellModels: [[TableViewCellModel]]
    
    // MARK: - Initialization
    
    init(cellModels: [[TableViewCellModel]])
    {
        self.cellModels = cellModels
    }
    
    // MARK: - Functions
    
    func numberOfRows() -> [Int]
    {
        cellModels.map {
            $0.count
        }
    }
}
