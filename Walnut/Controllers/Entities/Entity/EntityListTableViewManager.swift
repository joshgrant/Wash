//
//  EntityListTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class EntityListTableViewManager: NSObject
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    weak var context: Context?
    weak var navigationController: NavigationController?
    
    var cellModels: [[TableViewCellModel]]
    
    var tableView: UITableView
    
    var needsReload: Bool = false
    
    // MARK: - Initialization
    
    init(
        entityType: Entity.Type,
        context: Context?,
        navigationController: NavigationController?)
    {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        
        self.entityType = entityType
        self.context = context
        self.navigationController = navigationController
        self.cellModels = Self.makeCellModels(
            context: context,
            entityType: entityType)
        
        super.init()
        
        Self.makeCellModelTypes().forEach
        {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Functions
    
    func reloadIfNeeded()
    {
        refreshCellModels()
        tableView.reloadData()
        needsReload = false
    }
    
    // MARK: - Factory
    
    func refreshCellModels()
    {
        guard let context = context else
        {
            assertionFailure()
            return
        }
        
        self.cellModels = Self.makeCellModels(context: context, entityType: entityType)
    }
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            TextCellModel.self
        ]
    }
    
    static func makeCellModels(context: Context?, entityType: Entity.Type) -> [[TableViewCellModel]]
    {
        guard let context = context else { return [] }
        
        return [
            makeEntityListCellModels(
                context: context,
                entityType: entityType)
        ]
    }
    
    static func makeEntityListCellModels(context: Context, entityType: Entity.Type) -> [TableViewCellModel]
    {
        entityType
            .all(context: context)
            .compactMap { $0 as? Named }
            .map {
                TextCellModel(
                    title: $0.title,
                    disclosureIndicator: true)
            }
        
    }
}

extension EntityListTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let context = context, let navigationController = navigationController else
        {
            assertionFailure("Failed to get the prereqs")
            return
        }
        
        let all = entityType.all(context: context)
        let entity = all[indexPath.row]
        let detailController = entity.detailController(navigationController: navigationController)
        navigationController.pushViewController(detailController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration?
    {
        let actions = [
            makePinAction(forRowAt: indexPath),
            makeDeleteAction(forRowAt: indexPath, in: tableView)
        ].compactMap { $0 }
        
        return .init(actions: actions)
    }
}

extension EntityListTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        cellModels.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        cellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellModel = cellModels[indexPath.section][indexPath.row]
        return cellModel.makeCell(in: tableView, at: indexPath)
    }
}

// MARK: - Trailing swipe actions

extension EntityListTableViewManager
{
    func makePinAction(forRowAt indexPath: IndexPath) -> UIContextualAction?
    {
        guard let context = context else { return nil }
        
        let entities = entityType.all(context: context)
        let entity = entities[indexPath.row]
        let isPinned = entity.isPinned
        let title = isPinned ? "Unpin".localized : "Pin".localized
        let pinAction = UIContextualAction(style: .normal, title: title) { action, view, completion in
            completion(true)
        }
        return pinAction
    }
    
    func makeDeleteAction(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UIContextualAction?
    {
        let title = "Delete".localized
        
        return .init(style: .destructive, title: title) { action, view, completion in
            guard let context = self.context else
            {
                completion(false);
                return
            }
            
            context.perform
            {
                let object = self.entityType.all(context: context)[indexPath.row]
                context.delete(object)
                context.quickSave()
                
                self.refreshCellModels()
                
                DispatchQueue.main.async
                {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
            
            completion(true)
        }
    }
}
