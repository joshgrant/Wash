//
//  TableViewDataSourceModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

open class TableViewDataSourceModel
{
    // MARK: - Variables
    
    public var cellModels: [[TableViewCellModel]]
    
    // MARK: - Initialization
    
    required public init(cellModels: [[TableViewCellModel]])
    {
        self.cellModels = cellModels
    }
    
    // MARK: - Functions
    
    public func numberOfRows(section: Int) -> Int
    {
        cellModels[section].count
    }
    
    func reload()
    {
        assertionFailure("Override this method in your subclasses")
    }
}
