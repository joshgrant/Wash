//
//  TableViewDataSource.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class TableViewDataSource: NSObject
{
    // MARK: - Variables
    
    public var model: TableViewDataSourceModel
    
    // MARK: - Initialization
    
    public init(model: TableViewDataSourceModel)
    {
        self.model = model
    }
}

// MARK: - UITableViewDataSource

extension TableViewDataSource: UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        model.cellModels.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.numberOfRows(section: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellModel = model.cellModels[indexPath.section][indexPath.row]
        return cellModel.makeCell(in: tableView, at: indexPath)
    }
}
