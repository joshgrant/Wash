//
//  DashboardViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class DashboardViewController: ViewController
{
    var context: Context
    var tableView: TableView
    var dataSource: DashboardDataSource
    
    init(context: Context)
    {
        self.context = context
        self.tableView = TableView()
        self.dataSource = DashboardDataSource(context: context)
        super.init(title: "Dashboard")
        
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    override func loadView()
    {
        view = tableView
    }
}

extension DashboardViewController: TableViewDelegate
{
    func tableView(_ tableView: TableView, didSelectRowAt indexPath: Index)
    {
        guard let entity = dataSource.entity(at: indexPath.section, row: indexPath.row) as? Named else { return }
        let configuration = EntityType.configuration(for: entity)
        let controller = EntityDetailViewController(entity: entity, configuration: configuration)
        navigationController?.push(controller: controller)
    }
    
    func tableView(_ tableView: TableView, performAction action: String, forRowAtIndexPath indexPath: Index) {
        guard let entity = dataSource.entity(at: indexPath.section, row: indexPath.row) else { return }
        
        switch action
        {
        case "pin":
            entity.isPinned = true
        case "unpin":
            entity.isPinned = false
        default:
            return
        }
    }
}
