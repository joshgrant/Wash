//
//  TableViewDataSourceModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public struct TableViewDataSourceModel
{
    // MARK: - Variables
    
    var cellModels: [[TableViewCellModel]]
    
    // MARK: - Functions
    
    func numberOfRows() -> [Int]
    {
        cellModels.map {
            $0.count
        }
    }
}
