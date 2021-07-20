//
//  CurrentIdealController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

// TODO: Automatic "next" button updates when the data model changes...

class AnyTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var model: TableViewModel
    var stream: Stream
    var style: UITableView.Style
    
    // MARK: - Initialization
    
    init(container: TableViewDependencyContainer)
    {
        self.model = container.model
        self.stream = container.stream
        self.style = container.style
    }
}

class AnyTableView: TableView<AnyTableViewContainer>
{
}

protocol CurrentIdealControllerFactory: Factory
{
    func makeBooleanTableView() -> AnyTableView
    func makeNumericTableView() -> AnyTableView
    func makeStateTableView() -> AnyTableView
    func makeTableView() -> AnyTableView
    
    func makeRightBarButtonItem(target: CurrentIdealController) -> UIBarButtonItem
}

class CurrentIdealControllerDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var context: Context
    var stream: Stream
    var tableView: AnyTableView
    
    // MARK: - Initialization
    
    init(model: NewStockModel, context: Context, stream: Stream, tableView: AnyTableView? = nil)
    {
        self.model = model
        self.context = context
        self.stream = stream
        self.tableView = tableView ?? makeTableView()
    }
}

extension CurrentIdealControllerDependencyContainer: CurrentIdealControllerFactory
{
    func makeBooleanTableView() -> AnyTableView
    {
        let booleanContainer = CurrentIdealBooleanTableViewContainer(
            stream: stream,
            style: .grouped,
            newStockModel: model)
        let erasedContainer = AnyTableViewContainer(container: booleanContainer)
        return .init(container: erasedContainer)
    }
    
    func makeNumericTableView() -> AnyTableView
    {
        let container = CurrentIdealNumericTableViewContainer(
            newStockModel: model,
            stream: stream,
            style: .grouped)
        let erasedContainer = AnyTableViewContainer(container: container)
        return .init(container: erasedContainer)
    }
    
    func makeStateTableView() -> AnyTableView
    {
        let container = CurrentIdealStateTableViewContainer(
            stream: stream,
            style: .grouped,
            newStockModel: model)
        let erasedContainer = AnyTableViewContainer(container: container)
        return .init(container: erasedContainer)
    }
    
    func makeTableView() -> AnyTableView
    {
        if model.stockType == .boolean
        {
            makeBooleanTableView()
        }
        else if model.isStateMachine
        {
            return makeStateTableView()
        }
        else
        {
            return makeNumericTableView()
        }
    }
    
    func makeRightBarButtonItem(target: CurrentIdealController) -> UIBarButtonItem
    {
        let rightItem = UIBarButtonItem(systemItem: .done)
        rightItem.target = target
        rightItem.action = #selector(target.rightBarButtonItemDidTouchUpInside(_:))
        rightItem.isEnabled = model.validForCurrentIdeal
        return rightItem
    }
}

class CurrentIdealController: ViewController<CurrentIdealControllerDependencyContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: CurrentIdealControllerDependencyContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.embed(container.tableView)
        
        let rightItem = container.makeRightBarButtonItem(target: self)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    // MARK: - Functions
    
    @objc func rightBarButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        let stock = Stock(context: container.context)
        
        let title = Symbol(context: container.context)
        title.name = container.model.title
        stock.symbolName = title
        
        stock.unit = container.model.unit
        stock.valueType = container.model.stockType
        stock.stateMachine = container.model.isStateMachine
        
        let minimumSource = ValueSource(context: container.context)
        minimumSource.value = container.model.minimum ?? 0
        stock.minimum = minimumSource
        
        let maximumSource = ValueSource(context: container.context)
        maximumSource.value = container.model.maximum ?? 100
        stock.maximum = maximumSource
        
        if container.model.stockType == .boolean
        {
            let amountSource = BooleanSource(context: container.context)
            amountSource.value = container.model.currentBool ?? true
            stock.amount = amountSource
            
            let idealSource = BooleanSource(context: container.context)
            idealSource.value = container.model.idealBool ?? true
            stock.ideal = idealSource
        }
        else if container.model.stockType == .percent
        {
            let amountSource = ValueSource(context: container.context)
            amountSource.value = container.model.currentDouble ?? 0
            stock.amount = amountSource
            
            let idealSource = ValueSource(context: container.context)
            idealSource.value = container.model.idealDouble ?? 100
            stock.ideal = idealSource
        }
        
        container.context.quickSave()
        
        let message = EntityInsertionMessage(entity: stock)
        container.stream.send(message: message)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
}

extension CurrentIdealController: Subscriber
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
        case .currentBool(let state):
            container.model.currentBool = state
            container.tableView.reload(shouldReloadTableView: false)
            container.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        case .idealBool(let state):
            container.model.idealBool = state
            container.tableView.reload(shouldReloadTableView: false)
            container.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        case .currentState:
            // Open up the state picker view
            let container = StatePickerDependencyContainer(model: container.model, stateType: .current, stream: container.stream)
            let detail = StatePickerController(container: container)
            navigationController?.pushViewController(detail, animated: true)
        case .idealState:
            // Open up the state picker view
            let container = StatePickerDependencyContainer(model: container.model, stateType: .ideal, stream: container.stream)
            let detail = StatePickerController(container: container)
            navigationController?.pushViewController(detail, animated: true)
        case .statePicker:
            container.tableView.shouldReload = true
            navigationItem.rightBarButtonItem?.isEnabled = container.model.validForCurrentIdeal
        default:
            break
        }
    }
}
