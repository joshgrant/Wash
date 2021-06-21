//
//  DimensionDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class DimensionDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(dimension: Dimension)
    {
        let cellModels = Self.makeCellModels(dimension: dimension)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(dimension: Dimension) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class DimensionDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        dimension: Dimension,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            dimension: dimension,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(dimension: Dimension, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(dimension: Dimension, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(dimension: dimension, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class DimensionDetailTableViewModel: TableViewModel
{
    convenience init(
        dimension: Dimension,
        navigationController: NavigationController)
    {
        let delegateModel = DimensionDetailTableViewDelegateModel(
            dimension: dimension,
            navigationController: navigationController)
        let dataSourceModel = DimensionDetailTableViewDataSourceModel(
            dimension: dimension)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegateModel: delegateModel,
            dataSourceModel: dataSourceModel,
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            // TODO: Add cell model types
        ]
    }
}

class DimensionDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: DimensionDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: DimensionDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(dimension: Dimension, navigationController: NavigationController)
    {
        let tableViewModel = DimensionDetailTableViewModel(
            dimension: dimension,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class DimensionDetailView: View<DimensionDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<DimensionDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: DimensionDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class DimensionDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var dimension: Dimension
    
    var title: String { dimension.title }
    
    // MARK: - Initialization
    
    required init(dimension: Dimension)
    {
        self.dimension = dimension
    }
}

class DimensionDetailController: ViewController<
                            DimensionDetailControllerModel,
                            DimensionDetailViewModel,
                            DimensionDetailView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: DimensionDetailControllerModel,
        viewModel: DimensionDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(dimension: Dimension, navigationController: NavigationController)
    {
        let controllerModel = DimensionDetailControllerModel(dimension: dimension)
        let viewModel = DimensionDetailViewModel(
            dimension: dimension,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(dimension: dimension)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(dimension: dimension, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(dimension: Dimension) -> ActionClosure
    {
        dimension.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(dimension: Dimension, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: dimension.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
