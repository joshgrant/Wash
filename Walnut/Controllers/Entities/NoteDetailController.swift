//
//  NoteDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class NoteDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    convenience init(note: Note)
    {
        let cellModels = Self.makeCellModels(note: note)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(note: Note) -> [[TableViewCellModel]]
    {
        [
            // TODO: Add cell models
        ]
    }
}

class NoteDetailTableViewDelegateModel: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(
        note: Note,
        navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews(
            note: note,
            navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: headerViews.count.map { 44 },
            didSelect: nil)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViewModels(note: Note, navigationController: NavigationController) -> [TableHeaderViewModel]
    {
        [
        ]
    }
    
    static func makeHeaderViews(note: Note, navigationController: NavigationController) -> [TableHeaderView]
    {
        let models = makeHeaderViewModels(note: note, navigationController: navigationController)
        return models.map { TableHeaderView(model: $0) }
    }
}

class NoteDetailTableViewModel: TableViewModel
{
    convenience init(
        note: Note,
        navigationController: NavigationController)
    {
        let delegateModel = NoteDetailTableViewDelegateModel(
            note: note,
            navigationController: navigationController)
        let dataSourceModel = NoteDetailTableViewDataSourceModel(
            note: note)
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

class NoteDetailViewModel: ViewModel
{
    // MARK: - Variables
    
    var tableViewModel: NoteDetailTableViewModel
    
    // MARK: - Initialization
    
    required init(tableViewModel: NoteDetailTableViewModel)
    {
        self.tableViewModel = tableViewModel
    }
    
    convenience init(note: Note, navigationController: NavigationController)
    {
        let tableViewModel = NoteDetailTableViewModel(
            note: note,
            navigationController: navigationController)
        self.init(tableViewModel: tableViewModel)
    }
}

class NoteDetailView: View<NoteDetailViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<NoteDetailTableViewModel>
    
    // MARK: - Initialization
    
    required init(model: NoteDetailViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        super.init(model: model)
        embed(tableView)
    }
}

class NoteDetailControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var note: Note
    
    var title: String { note.title }
    
    // MARK: - Initialization
    
    required init(note: Note)
    {
        self.note = note
    }
}

class NoteDetailController: ViewController<
                            NoteDetailControllerModel,
                            NoteDetailViewModel,
                            NoteDetailView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: NoteDetailControllerModel,
        viewModel: NoteDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(note: Note, navigationController: NavigationController)
    {
        let controllerModel = NoteDetailControllerModel(note: note)
        let viewModel = NoteDetailViewModel(
            note: note,
            navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(note: note)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(note: note, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(note: Note) -> ActionClosure
    {
        note.togglePinAction()
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(note: Note, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: note.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
