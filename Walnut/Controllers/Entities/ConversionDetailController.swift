//
//  ConversionDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class ConversionDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(conversion: Conversion)
    {
        let cellModels = Self.makeCellModels(conversion: conversion)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(conversion: Conversion) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class ConversionDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        conversion: Conversion,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            conversion: conversion,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(conversion: Conversion, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(conversion: Conversion, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(conversion: conversion, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class ConversionDetailTableViewModel: TableViewModel
{
    convenience init(
        conversion: Conversion,
        navigationController: NavigationController)
    {
        let delegateModel = ConversionDetailTableViewDelegateModel(
            conversion: conversion,
            navigationController: navigationController)
        let dataSourceModel = ConversionDetailTableViewDataSourceModel(
            conversion: conversion)
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

class ConversionDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: ConversionDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: ConversionDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(conversion: Conversion, navigationController: NavigationController)
    {
        let tableViewModel = ConversionDetailTableViewModel(
            conversion: conversion,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class ConversionDetailView: View<ConversionDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<ConversionDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: ConversionDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class ConversionDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var conversion: Conversion
    
    var title: String { conversion.title }
    
    // MARK: - Initialization
    
    required init(conversion: Conversion)
    {
        self.conversion = conversion
    }
}

class ConversionDetailController: ViewController<
                            ConversionDetailControllerModel,
                            ConversionDetailViewModel,
                            ConversionDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: ConversionDetailControllerModel,
        viewModel: ConversionDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(conversion: Conversion, navigationController: NavigationController)
    {
        let controllerModel = ConversionDetailControllerModel(conversion: conversion)
        let viewModel = ConversionDetailViewModel(
            conversion: conversion,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(conversion: conversion)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(conversion: conversion, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(conversion: Conversion) -> ActionClosure
    {
        conversion.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(conversion: Conversion, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: conversion.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
