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
    
    lazy var data = loadData()
    
    init(entity: Named, configuration: DataSource)
    {
        self.entity = entity
        self.configuration = configuration
        self.tableView = TableView()
        super.init(title: "\(EntityType.type(from: entity)?.icon.text ?? "") \(entity.title)")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func loadView()
    {
        view = tableView
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
            if let handler = configuration.commandHandler
            {
                // TODO: Even with a valid command handler, might not handle this command, i.e return
                handler(entity, command)
                // TODO: No clear API coms that this needs to reload the table view (our data is lazy)
                reloadData()
            }
            else
            {
                super.handle(command: command)
            }
        }
    }
    
    // MARK: - Reloading
    
    private func loadData() -> [Dictionary<DataSource.Section, [DataSource.Row]>.Element]
    {
        return configuration.dataProvider(entity).sorted { $0.key < $1.key }
    }
    
    private func reloadData()
    {
        data = loadData()
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
        return TableViewCell(components: [.label(text: value.description)])
    }
    
    func tableView(_ tableView: TableView, titleForHeaderInSection section: Int) -> String?
    {
        let title = data[section].key
        return "\(section). \(title)"
    }
}
