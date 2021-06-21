//
//  TransferFlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class TransferFlowDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(flow: TransferFlow)
    {
        let cellModels = Self.makeCellModels(flow: flow)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(flow: TransferFlow) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
            
            // Info
            [
                // Title edit
                // amount (detail)
                // from (detail)
                // to (detail)
                // duration (detail)
                // require user completion (toggle)
            ],
            // Events
            [
                // detail
            ],
            // History
            [
                // detail
            ]
        ]
    }
}

class TransferFlowDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    // TODO: Add a footer for the info section
    // "Adds a to-do button in the dashboard
    
    convenience init(
        flow: TransferFlow,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            flow: flow,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(flow: TransferFlow, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
            // Info,
            // Events
            // History
        ]
    }
    
    static func makeHeaderViews(flow: TransferFlow, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(flow: flow, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class TransferFlowDetailTableViewModel: TableViewModel
{
    convenience init(
        flow: TransferFlow,
        navigationController: NavigationController)
    {
        let delegateModel = TransferFlowDetailTableViewDelegateModel(
            flow: flow,
            navigationController: navigationController)
        let dataSourceModel = TransferFlowDetailTableViewDataSourceModel(
            flow: flow)
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

class TransferFlowDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: TransferFlowDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: TransferFlowDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(flow: TransferFlow, navigationController: NavigationController)
    {
        let tableViewModel = TransferFlowDetailTableViewModel(
            flow: flow,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class TransferFlowDetailView: View<TransferFlowDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<TransferFlowDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: TransferFlowDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class TransferFlowDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var flow: TransferFlow
    
    var title: String { flow.title }
    
    // MARK: - Initialization
    
    required init(flow: TransferFlow)
    {
        self.flow = flow
    }
}

class TransferFlowDetailController: ViewController<
                            TransferFlowDetailControllerModel,
                            TransferFlowDetailViewModel,
                            TransferFlowDetailView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: TransferFlowDetailControllerModel,
        viewModel: TransferFlowDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(flow: TransferFlow, navigationController: NavigationController)
    {
        let controllerModel = TransferFlowDetailControllerModel(flow: flow)
        let viewModel = TransferFlowDetailViewModel(
            flow: flow,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(flow: flow)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(flow: flow, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(flow: TransferFlow) -> ActionClosure
    {
        flow.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(flow: TransferFlow, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: flow.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
