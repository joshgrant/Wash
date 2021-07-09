//
//  LibraryTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class LibraryTableViewManager: NSObject
{
    // MARK: - Variables
    
    var cellModels: [[TableViewCellModel]]
    
    var tableView: UITableView
    
    // MARK: - Initialization
    
    init(context: Context)
    {
        self.cellModels = Self.makeCellModels(context: context)
        self.tableView = UITableView(frame: .zero, style: .grouped)
        
        super.init()
        
        Self.cellModelTypes().forEach
        {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Functions
    
    static func cellModelTypes() -> [TableViewCellModel.Type]
    {
        [LibraryCellModel.self]
    }
    
    static func makeCellModels(context: Context) -> [[TableViewCellModel]]
    {
        let cellModels = EntityType.libraryVisible.map
        {
            LibraryCellModel(entityType: $0, context: context)
        }
        
        return [cellModels]
    }
}

extension LibraryTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = LibraryCellSelectionMessage(
            tableView: tableView,
            indexPath: indexPath)
        AppDelegate.shared.mainStream.send(message: message)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        44
    }
}

extension LibraryTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = cellModels[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
}
