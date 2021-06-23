//
//  ProcessDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class ProcessFlowDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(processFlow: ProcessFlow)
    {
        let cellModels = Self.makeCellModels(processFlow: processFlow)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(processFlow: ProcessFlow) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class ProcessFlowDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        processFlow: ProcessFlow,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            processFlow: processFlow,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(processFlow: ProcessFlow, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(processFlow: ProcessFlow, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(processFlow: processFlow, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class ProcessFlowDetailTableViewModel: TableViewModel
{
    convenience init(
        processFlow: ProcessFlow,
        navigationController: NavigationController)
    {
        let delegateModel = ProcessFlowDetailTableViewDelegateModel(
            processFlow: processFlow,
            navigationController: navigationController)
        let dataSourceModel = ProcessFlowDetailTableViewDataSourceModel(
            processFlow: processFlow)
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

class ProcessFlowDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: ProcessFlowDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: ProcessFlowDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(processFlow: ProcessFlow, navigationController: NavigationController)
    {
        let tableViewModel = ProcessFlowDetailTableViewModel(
            processFlow: processFlow,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class ProcessFlowDetailView: View<ProcessFlowDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<ProcessFlowDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: ProcessFlowDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class ProcessFlowDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var processFlow: ProcessFlow
    
    var title: String { processFlow.title }
    
    // MARK: - Initialization
    
    required init(processFlow: ProcessFlow)
    {
        self.processFlow = processFlow
    }
}

class ProcessFlowDetailController: ViewController<
                            ProcessFlowDetailControllerModel,
                            ProcessFlowDetailViewModel,
                            ProcessFlowDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: ProcessFlowDetailControllerModel,
        viewModel: ProcessFlowDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(processFlow: ProcessFlow, navigationController: NavigationController)
    {
        let controllerModel = ProcessFlowDetailControllerModel(processFlow: processFlow)
        let viewModel = ProcessFlowDetailViewModel(
            processFlow: processFlow,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(processFlow: processFlow)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(processFlow: processFlow, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(processFlow: ProcessFlow) -> ActionClosure
    {
        processFlow.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(processFlow: ProcessFlow, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: processFlow.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
