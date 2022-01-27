//
//  EntityDetailViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/22/22.
//

import Foundation
import Protyper

/// The detail view controller is responsible for showing all of the different
/// entity details. They have a configuration (which sections they want)
/// as well as information on how to access the data in those sections. Because
/// a lof of sections are reused (notes, for example) this reduces some duplication
class EntityDetailViewController: ViewController
{
    var entity: Named
    var configuration: DataSource
    var tableView: TableView
    
    lazy var data = configuration.dataProvider(entity).sorted { $0.key < $1.key }
    
    init(entity: Named, configuration: DataSource)
    {
        self.entity = entity
        self.configuration = configuration
        self.tableView = TableView()
        super.init(title: entity.title, view: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear()
    {
        super.viewWillAppear()
        navigationItem?.rightItem = entity.isPinned ? Icon.pinFill.text : Icon.pin.text
    }
    
    override func handle(command: Command)
    {
        switch command.rawString
        {
        case "pin":
            entity.isPinned = true
        case "unpin":
            entity.isPinned = false
        default:
            super.handle(command: command)
        }
        
        entity.managedObjectContext?.quickSave()
    }
}

extension EntityDetailViewController: TableViewDelegate
{
    
}

extension EntityDetailViewController: TableViewDataSource
{
    func numberOfSections(in tableView: TableView) -> Int
    {
        data.count
    }
    
    func tableView(_ tableView: TableView, numberOfRowsInSection section: Int) -> Int
    {
        data[section].value.count
    }
    
    func tableView(_ tableView: TableView, cellForRowAt indexPath: Index) -> TableViewCell
    {
        let value = data[indexPath.section].value[indexPath.row]
        return TableViewCell(contentView: nil, accessories: [.label(text: value.description)])
    }
    
    func tableView(_ tableView: TableView, titleForHeaderInSection section: Int) -> String?
    {
        let title = data[section].key
        return "\(section). \(title)"
    }
}
