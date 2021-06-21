//
//  UnitDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class UnitDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(unit: Unit)
    {
        let cellModels = Self.makeCellModels(unit: unit)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(unit: Unit) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class UnitDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        unit: Unit,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            unit: unit,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(unit: Unit, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(unit: Unit, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(unit: unit, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class UnitDetailTableViewModel: TableViewModel
{
    convenience init(
        unit: Unit,
        navigationController: NavigationController)
    {
        let delegateModel = UnitDetailTableViewDelegateModel(
            unit: unit,
            navigationController: navigationController)
        let dataSourceModel = UnitDetailTableViewDataSourceModel(
            unit: unit)
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

class UnitDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: UnitDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: UnitDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(unit: Unit, navigationController: NavigationController)
    {
        let tableViewModel = UnitDetailTableViewModel(
            unit: unit,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class UnitDetailView: View<UnitDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<UnitDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: UnitDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class UnitDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var unit: Unit
    
    var title: String { unit.title }
    
    // MARK: - Initialization
    
    required init(unit: Unit)
    {
        self.unit = unit
    }
}

class UnitDetailController: ViewController<
                            UnitDetailControllerModel,
                            UnitDetailViewModel,
                            UnitDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: UnitDetailControllerModel,
        viewModel: UnitDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(unit: Unit, navigationController: NavigationController)
    {
        let controllerModel = UnitDetailControllerModel(unit: unit)
        let viewModel = UnitDetailViewModel(
            unit: unit,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(unit: unit)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(unit: unit, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(unit: Unit) -> ActionClosure
    {
        unit.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(unit: Unit, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: unit.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
