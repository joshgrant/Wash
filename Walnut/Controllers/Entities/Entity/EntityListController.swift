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
    // MARK: - Initialization

    convenience init(
        context: Context,
        navigationController: NavigationController,
        type: Entity.Type)
    {
        let controllerModel = EntityListControllerModel(
            type: type)
        let viewModel = EntityListViewModel(
            context: context,
            navigationController: navigationController,
            entityType: type)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = controllerModel.title
        navigationItem.rightBarButtonItem = _view.barButtonItem
        
        let controller = Self.makeSearchController(searchControllerDelegate: self)
        
        navigationItem.searchController = controller
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
//        if stateMachine.dirty
//        {
//            interactor.reload()
//            stateMachine.dirty = false
//        }
    }
    
    // MARK: - Factory
    
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
