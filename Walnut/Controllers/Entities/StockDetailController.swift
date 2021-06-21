//
//  StockDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class StockDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(stock: Stock)
    {
        let cellModels = Self.makeCellModels(stock: stock)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(stock: Stock) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
            // Info
            [
                // title edit
                // type (detail, disclosure)
                // dimension (detail)
                // current (small subtitle, detail, disclosure)
                // net (detail, info)
            ],
            // States
            [
                // state cell (target, title, detail)
            ],
            // Inflows
            [
                // Title, subtitle, detail, disclosure
            ],
            // Outflows
            [
                // Title, subtitle, detail, disclosure
            ],
            // Events
            [
                // Title, detail, disclosure
            ]
        ]
    }
}

class StockDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        stock: Stock,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            stock: stock,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(stock: Stock, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(stock: Stock, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(stock: stock, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class StockDetailTableViewModel: TableViewModel
{
    convenience init(
        stock: Stock,
        navigationController: NavigationController)
    {
        let delegateModel = StockDetailTableViewDelegateModel(
            stock: stock,
            navigationController: navigationController)
        let dataSourceModel = StockDetailTableViewDataSourceModel(
            stock: stock)
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

class StockDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: StockDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: StockDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(stock: Stock, navigationController: NavigationController)
    {
        let tableViewModel = StockDetailTableViewModel(
            stock: stock,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class StockDetailView: View<StockDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<StockDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: StockDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class StockDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var stock: Stock
    
    var title: String { stock.title }
    
    // MARK: - Initialization
    
    required init(stock: Stock)
    {
        self.stock = stock
    }
}

class StockDetailController: ViewController<
                            StockDetailControllerModel,
                            StockDetailViewModel,
                            StockDetailView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: StockDetailControllerModel,
        viewModel: StockDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(stock: Stock, navigationController: NavigationController)
    {
        let controllerModel = StockDetailControllerModel(stock: stock)
        let viewModel = StockDetailViewModel(
            stock: stock,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(stock: stock)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(stock: stock, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(stock: Stock) -> ActionClosure
    {
        stock.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(stock: Stock, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: stock.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
