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

protocol StatePickerFactory: Factory
{
    func makeTableView() -> TableView<StatePickerTableViewContainer>
}

class StatePickerDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var stateType: StateType
    var stream: Stream
    
    // MARK: - Initialization
    
    init(model: NewStockModel, stateType: StateType, stream: Stream)
    {
        self.model = model
        self.stateType = stateType
        self.stream = stream
    }
}

extension StatePickerDependencyContainer: StatePickerFactory
{
    func makeTableView() -> TableView<StatePickerTableViewContainer>
    {
        let container = StatePickerTableViewContainer(
            newStockModel: model,
            stateType: stateType,
            stream: stream,
            style: .grouped)
        return .init(container: container)
    }
}

class StatePickerController: ViewController<StatePickerDependencyContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    var tableView: TableView<StatePickerTableViewContainer>

    // MARK: - Initialization
    
    required init(container: StatePickerDependencyContainer)
    {
        tableView = container.makeTableView()
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
        view.embed(tableView)
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
            switch container.stateType
            {
            case .current:
                container.model.currentState = state
            case .ideal:
                container.model.idealState = state
            }
        default:
            break
        }
        
        navigationController?.popViewController(animated: true)
    }
}

protocol StatePickerTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeStatesSection() -> TableViewSection
}

class StatePickerTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    var stateType: StateType
    var stream: Stream
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, stateType: StateType, stream: Stream, style: UITableView.Style)
    {
        self.newStockModel = newStockModel
        self.stateType = stateType
        self.stream = stream
        self.style = style
    }
}

extension StatePickerTableViewContainer: StatePickerTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeStatesSection()
        ])
    }
    
    func makeStatesSection() -> TableViewSection
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
