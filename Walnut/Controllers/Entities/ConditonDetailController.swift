//
//  ConditonDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit

class ConditionDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(condition: Condition)
    {
        let cellModels = Self.makeCellModels(condition: condition)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(condition: Condition) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
            [
                // detail, disclosure
                // detail, disclosure
                // green, detail, info, disclosure
                // green, detail, info, disclosure
            ]
        ]
    }
}

class ConditionDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        condition: Condition,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            condition: condition,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(condition: Condition, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
            // Condition
        ]
    }
    
    static func makeHeaderViews(condition: Condition, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(condition: condition, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class ConditionDetailTableViewModel: TableViewModel
{
    convenience init(
        condition: Condition,
        navigationController: NavigationController)
    {
        let delegateModel = ConditionDetailTableViewDelegateModel(
            condition: condition,
            navigationController: navigationController)
        let dataSourceModel = ConditionDetailTableViewDataSourceModel(
            condition: condition)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegate: .init(model: delegateModel),
            dataSource: .init(model: dataSourceModel),
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

class ConditionDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: ConditionDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: ConditionDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(condition: Condition, navigationController: NavigationController)
    {
        let tableViewModel = ConditionDetailTableViewModel(
            condition: condition,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class ConditionDetailView: View<ConditionDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<ConditionDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: ConditionDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class ConditionDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var condition: Condition
    
    var title: String { condition.title }
    
    // MARK: - Initialization
    
    required init(condition: Condition)
    {
        self.condition = condition
    }
}

/// This is visible in the event detal, by adding a condition
class ConditionDetailController: ViewController<
                            ConditionDetailControllerModel,
                            ConditionDetailViewModel,
                            ConditionDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: ConditionDetailControllerModel,
        viewModel: ConditionDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(condition: Condition, navigationController: NavigationController)
    {
        let controllerModel = ConditionDetailControllerModel(condition: condition)
        let viewModel = ConditionDetailViewModel(
            condition: condition,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(condition: condition)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(condition: condition, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(condition: Condition) -> ActionClosure
    {
        condition.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(condition: Condition, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: condition.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
