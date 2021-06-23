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
    var interactor = EntityListInteractor()
    
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
        
        title = controllerModel.title
        navigationItem.rightBarButtonItem = Self.makeAddBarButtonItem(model: controllerModel)
        
        let controller = Self.makeSearchController(searchControllerDelegate: self)
        
        navigationItem.searchController = controller
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if stateMachine.dirty
        {
            interactor.reload()
            stateMachine.dirty = false
        }
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

extension EntityListController: UISearchControllerDelegate
{
    
}
