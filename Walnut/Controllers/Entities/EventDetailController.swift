//
//  EventDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit

class EventDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(event: Event)
    {
        let cellModels = Self.makeCellModels(event: event)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(event: Event) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
            
            // Info
            [
                // Title edit
                // Active (toggle)
            ],
            // Conditions
            [
                // Condition (green, detail, info, disclosure)
                // (then a list of conditions)
                // title (detail, disclosure)
            ],
            // Flows
            [
                // title, disclosure
            ],
            // History
            [
                // Title, disclosure
            ]
        ]
    }
}

class EventDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        event: Event,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            event: event,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(event: Event, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
            // Info
            // Conditions
            // Flows
            // History
        ]
    }
    
    static func makeHeaderViews(event: Event, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(event: event, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class EventDetailTableViewModel: TableViewModel
{
    convenience init(
        event: Event,
        navigationController: NavigationController)
    {
        let delegateModel = EventDetailTableViewDelegateModel(
            event: event,
            navigationController: navigationController)
        let dataSourceModel = EventDetailTableViewDataSourceModel(
            event: event)
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

class EventDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: EventDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: EventDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(event: Event, navigationController: NavigationController)
    {
        let tableViewModel = EventDetailTableViewModel(
            event: event,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class EventDetailView: View<EventDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<EventDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: EventDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class EventDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var event: Event
    
    var title: String { event.title }
    
    // MARK: - Initialization
    
    required init(event: Event)
    {
        self.event = event
    }
}

class EventDetailController: ViewController<
                            EventDetailControllerModel,
                            EventDetailViewModel,
                            EventDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: EventDetailControllerModel,
        viewModel: EventDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(event: Event, navigationController: NavigationController)
    {
        let controllerModel = EventDetailControllerModel(event: event)
        let viewModel = EventDetailViewModel(
            event: event,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(event: event)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(event: event, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(event: Event) -> ActionClosure
    {
        event.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(event: Event, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: event.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
