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
        super.init(title: "Library")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func loadView()
    {
        view = tableView
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
            let nav = NavigationController(root: controller)
            present(controller: nav)
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
        return TableViewCell(components: [.label(text: text)])
    }
}
