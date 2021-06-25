//
//  EntityListInteractor.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation

protocol Interactor: AnyObject {}

class EntityListInteractor: Interactor
{
    // MARK: - Variables
    
    var router: EntityListRouter
    
    // MARK: - Initialization
    
    init(router: EntityListRouter)
    {
        self.router = router
    }
    
    // MARK: - Functions
    
    // Navigate back up the navigation stack
    // Let's use a router for this
    func back()
    {
        router
            .navigationController?
            .popViewController(animated: true)
    }
    
    func select(entity: Entity)
    {
        // 1. Router
        
        // Using a router, display the detail page
    }
    
//    // Get the entity
//    // Using a router, display the new window
//    func selectRow(at: IndexPath)
//    {
//        
//    }
    
    // The Swipe-To-Pin action
    func pinRow(at: IndexPath)
    {
        // 1. Index Path
        // 2. Context
        // 3. Entity Type (or just the entity?)
        //
    }
    
    func deleteRow(at: IndexPath)
    {
        // 1. Index Path
        // 2. Context
        // 3. Entity Type
        // 4. Table View
    }
    
    /// We need to reload the entity list when any of the
    /// detail views make a change to either the title or
    /// the detail text of the entity
    func reload()
    {
        // 1. Table View Data Source Model
        // 2. Table View
        // TODO: Get the things specifically, without any extra crap
//        (self._view.model.tableViewModel.dataSource.model as? EntityListTableViewDataSourceModel)?.reload()
//        self._view.tableView.reloadData()
    }
    
    // Create a new entity
    // Display a new window (router)
    func add()
    {
        // 1. Entity Type
        // 2. Context
        // 3. NavigationController
        
        
//        let entity = type.init(context: context)
//        let detailController = entity.detailController(navigationController: navigationController, stateMachine: stateMachine)
//        navigationController.pushViewController(detailController, animated: true)
//        context.quickSave()
    }
}
