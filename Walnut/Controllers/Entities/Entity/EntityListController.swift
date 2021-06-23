//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import UIKit
import ProgrammaticUI

class EntityListController: ViewController<
                                EntityListControllerModel,
                                EntityListViewModel,
                                EntityListView>
{
    // MARK: - Variables
    
    var stateMachine: EntityListStateMachine
    
    // MARK: - Initialization
    
    init(
        controllerModel: EntityListControllerModel,
        viewModel: EntityListViewModel,
        stateMachine: EntityListStateMachine)
    {
        self.stateMachine = stateMachine
        
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
    
    convenience init(
        context: Context,
        navigationController: NavigationController,
        type: Entity.Type)
    {
        let stateMachine = EntityListStateMachine(current: .unloaded)
        let controllerModel = EntityListControllerModel(
            context: context,
            navigationController: navigationController,
            type: type,
            stateMachine: stateMachine)
        let viewModel = EntityListViewModel(
            context: context,
            navigationController: navigationController,
            type: type,
            stateMachine: stateMachine)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel,
            stateMachine: stateMachine)
        
//        handleNotifications(true)
        
        title = controllerModel.title
        navigationItem.rightBarButtonItem = Self.makeAddBarButtonItem(model: controllerModel)
        
        let controller = Self.makeSearchController(searchControllerDelegate: self)
        
        navigationItem.searchController = controller
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - View lifecycle
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        stateMachine.transition(to: .layingOutSubviews)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        stateMachine.transition(to: .waiting)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stateMachine.transition(to: .loaded)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        stateMachine.transition(to: .appearing)
        
        if stateMachine.dirty
        {
            // TODO: Cleanup
            (self._view.model.tableViewModel.dataSource.model as? EntityListTableViewDataSourceModel)?.reload()
            self._view.tableView.reloadData()
            stateMachine.dirty = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        stateMachine.transition(to: .waiting)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        stateMachine.transition(to: .disappearing)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        stateMachine.transition(to: .unloaded)
    }
    
    // MARK: - Factory
    
    static func makeAddBarButtonItem(model: EntityListControllerModel) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: model.addButtonImage,
            style: model.addButtonStyle,
            target: model.addAction,
            action: #selector(model.addAction.perform(sender:)))
    }
    
    static func makeSearchController(searchControllerDelegate: UISearchControllerDelegate) -> UISearchController
    {
        // TODO: Make a better results controller
        let searchResultsController = UIViewController()
        searchResultsController.view.backgroundColor = .green
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = searchControllerDelegate
        return searchController
    }
}

// MARK: - Notifications

//extension EntityListController: Notifiable
//{
//    func startObservingNotifications()
//    {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handleTitleUpdateNotification(_:)),
//            name: .titleUpdate,
//            object: nil)
//    }
//    
//    // MARK: Handlers
//    
//    @objc func handleTitleUpdateNotification(_ notification: Notification)
//    {
//        DispatchQueue.main.async {
//            (self._view.model.tableViewModel.dataSource.model as? EntityListTableViewDataSourceModel)?.reload()
//            self._view.tableView.reloadData()
//        }
//    }
//}

extension EntityListController: UISearchControllerDelegate
{
    
}
