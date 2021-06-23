//
//  SymbolDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class SymbolDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(symbol: Symbol)
    {
        let cellModels = Self.makeCellModels(symbol: symbol)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(symbol: Symbol) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class SymbolDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        symbol: Symbol,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            symbol: symbol,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(symbol: Symbol, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(symbol: Symbol, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(symbol: symbol, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class SymbolDetailTableViewModel: TableViewModel
{
    convenience init(
        symbol: Symbol,
        navigationController: NavigationController)
    {
        let delegateModel = SymbolDetailTableViewDelegateModel(
            symbol: symbol,
            navigationController: navigationController)
        let dataSourceModel = SymbolDetailTableViewDataSourceModel(
            symbol: symbol)
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

class SymbolDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: SymbolDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: SymbolDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(symbol: Symbol, navigationController: NavigationController)
    {
        let tableViewModel = SymbolDetailTableViewModel(
            symbol: symbol,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class SymbolDetailView: View<SymbolDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<SymbolDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: SymbolDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class SymbolDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var symbol: Symbol
    
    var title: String { symbol.name ?? "" }
    
    // MARK: - Initialization
    
    required init(symbol: Symbol)
    {
        self.symbol = symbol
    }
}

class SymbolDetailController: ViewController<
                            SymbolDetailControllerModel,
                            SymbolDetailViewModel,
                            SymbolDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: SymbolDetailControllerModel,
        viewModel: SymbolDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(symbol: Symbol, navigationController: NavigationController)
    {
        let controllerModel = SymbolDetailControllerModel(symbol: symbol)
        let viewModel = SymbolDetailViewModel(
            symbol: symbol,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(symbol: symbol)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(symbol: symbol, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(symbol: Symbol) -> ActionClosure
    {
        symbol.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(symbol: Symbol, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: symbol.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
