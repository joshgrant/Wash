//
//  LibraryViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class LibraryViewController: ViewController
{
    var context: Context
    var tableView: TableView
    
    init(context: Context)
    {
        self.context = context
        self.tableView = TableView()
        super.init(title: "Library", view: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LibraryViewController: TableViewDelegate
{
    func tableView(_ tableView: TableView, didSelectRowAt indexPath: Index)
    {
        let type = EntityType.libraryVisible[indexPath.row]
        let controller = EntityListViewController(entityType: type, context: context)
        navigationController?.push(controller: controller)
    }
    
    func tableView(_ tableView: TableView, performAction action: String, forRowAtIndexPath indexPath: Index)
    {
        let type = EntityType.libraryVisible[indexPath.row]
        
        switch action
        {
        case "add", "+":
            let controller = NewEntityViewController(entityType: type, context: context)
            navigationController?.push(controller: controller)
        default:
            break
        }
    }
}

extension LibraryViewController: TableViewDataSource
{
    func tableView(_ tableView: TableView, numberOfRowsInSection section: Int) -> Int
    {
        EntityType.libraryVisible.count
    }
    
    func tableView(_ tableView: TableView, cellForRowAt indexPath: Index) -> TableViewCell
    {
        let entityType = EntityType.libraryVisible[indexPath.row]
        let index = indexPath.row
        let name = entityType.title
        let count = entityType.count(in: context)
        let icon = entityType.icon.text
        
        let text = "\(index): \(icon) \(name) (\(count))"
        return TableViewCell(contentView: nil, accessories: [.label(text: text)])
    }
}
