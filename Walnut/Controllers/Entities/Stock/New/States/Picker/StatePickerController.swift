//
//  StatePickerController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/16/21.
//

import Foundation
import UIKit

enum StateType
{
    case current
    case ideal
}

class StatePickerDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var stateType: StateType
    var stream: Stream
    var tableView: StatePickerTableView
    
    // MARK: - Initialization
    
    init(model: NewStockModel, stateType: StateType, stream: Stream, tableView: StatePickerTableView? = nil)
    {
        self.model = model
        self.stateType = stateType
        self.stream = stream
        self.tableView = tableView ?? StatePickerTableView(newStockModel: model, stateType: stateType)
    }
}

class StatePickerController: ViewController<StatePickerDependencyContainer>
{
    // MARK: - Variables
    
    var id = UUID()

    // MARK: - Initialization
    
    override init(container: StatePickerDependencyContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.embed(container.tableView)
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
            if container.isCurrent
            {
                container.model.currentState = state
            }
            else
            {
                container.model.idealState = state
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
    var stateType: StateType
    
    // MARK: - Initialization

    init(newStockModel: NewStockModel, stateType: StateType)
    {
        self.newStockModel = newStockModel
        self.stateType = stateType
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
            let checked: Bool
            
            switch stateType
            {
            case .current:
                checked = state == newStockModel.currentState
            case .ideal:
                checked = state == newStockModel.idealState
            }
            
            return CheckmarkCellModel(
                selectionIdentifier: .statePicker(state: state),
                title: state.title!,
                checked: checked)
        }
        
        return TableViewSection(
            header: .stateMachine,
            models: models)
    }
}
