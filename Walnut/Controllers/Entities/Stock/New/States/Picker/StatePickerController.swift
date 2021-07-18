//
//  StatePickerController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/16/21.
//

import Foundation
import UIKit

class StatePickerController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    var newStockModel: NewStockModel
    var tableView: StatePickerTableView
    var isCurrent: Bool
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, isCurrent: Bool)
    {
        self.newStockModel = newStockModel
        self.isCurrent = isCurrent
        tableView = StatePickerTableView(
            newStockModel: newStockModel,
            isCurrent: isCurrent)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
}

extension StatePickerController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .statePicker(let state):
            if isCurrent
            {
                newStockModel.currentState = state
            }
            else
            {
                newStockModel.idealState = state
            }
        default:
            break
        }
        
        navigationController?.popViewController(animated: true)
    }
}

class StatePickerTableView: TableView
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    // TODO: Not great
    var isCurrent: Bool // If not, then it's ideal
    
    // MARK: - Initialization

    init(newStockModel: NewStockModel, isCurrent: Bool)
    {
        self.newStockModel = newStockModel
        self.isCurrent = isCurrent
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeStatesSection(newStockModel: newStockModel)
        ])
    }
    
    private func makeStatesSection(newStockModel: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = newStockModel.states.map { state in
            CheckmarkCellModel(
                selectionIdentifier: .statePicker(state: state),
                title: state.title!,
                checked: isCurrent
                    ? state == newStockModel.currentState
                    : state == newStockModel.idealState)
        }
        
        return TableViewSection(
            header: .stateMachine,
            models: models)
    }
}
