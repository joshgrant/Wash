//
//  NewUnitController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol NewUnitFactory: Factory
{
    func makeController() -> NewUnitController
    func makeTableView() -> NewUnitTableView
    func makeLeftItem(target: NewUnitController) -> UIBarButtonItem
    func makeRightItem(target: NewUnitController) -> UIBarButtonItem
}

class NewUnitContainer: Container
{
    var model: NewUnitModel
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.model = NewUnitModel()
        self.context = context
        self.stream = stream
    }
}

extension NewUnitContainer: NewUnitFactory
{
    func makeController() -> NewUnitController
    {
        .init(container: self)
    }
    
    func makeTableView() -> NewUnitTableView
    {
        let container = NewUnitTableViewContainer(
            stream: stream,
            style: .grouped,
            newUnitModel: model)
        return container.makeTableView()
    }
    
    // TODO: Target should be a responder protocol
    
    func makeLeftItem(target: NewUnitController) -> UIBarButtonItem
    {
        let leftItem = UIBarButtonItem(systemItem: .cancel)
        leftItem.target = target
        leftItem.action = #selector(target.cancelDidTouchUpInside(_:))
        return leftItem
    }
    
    func makeRightItem(target: NewUnitController) -> UIBarButtonItem
    {
        let rightItem = UIBarButtonItem(systemItem: .save)
        rightItem.target = target
        rightItem.action = #selector(target.saveDidTouchUpInside(_:))
        rightItem.isEnabled = false
        return rightItem
    }
}

class NewUnitController: ViewController<NewUnitContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    var tableView: NewUnitTableView
    
    // MARK: - Initialization
    
    required init(container: NewUnitContainer)
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
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = container.makeLeftItem(target: self)
        navigationItem.rightBarButtonItem = container.makeRightItem(target: self)
        
        view.embed(tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: - Functions
    
    @objc func cancelDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        let unit = Unit(context: container.context)
        
        let symbol = Symbol(context: container.context)
        symbol.name = container.model.title
        unit.symbolName = symbol
        
        unit.abbreviation = container.model.symbol
        unit.isBase = container.model.isBaseUnit
        unit.relativeTo = container.model.relativeTo
        
        container.context.quickSave()
        
        navigationController?.popViewController(animated: true)
    }
}

extension NewUnitController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as ToggleCellMessage:
            handle(m)
        case let m as RightEditCellMessage:
            handle(m)
        case let m as TableViewSelectionMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: ToggleCellMessage)
    {
        container.model.isBaseUnit = message.state
        navigationItem.rightBarButtonItem?.isEnabled = container.model.valid
        tableView.reloadForToggle(message: message)
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        switch message.selectionIdentifier
        {
        case .newUnitName:
            container.model.title = message.content
        case .newUnitSymbol:
            container.model.symbol = message.content
        default:
            break
        }
        navigationItem.rightBarButtonItem?.isEnabled = container.model.valid
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        let container = LinkSearchControllerContainer(
            context: container.context,
            stream: container.stream,
            origin: .newUnit(id: id),
            hasAddButton: true,
            entityType: Unit.self)
        let controller = container.makeController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        switch message.origin
        {
        case .newUnit(let id):
            guard id == self.id else { return }
            guard let unit = message.link as? Unit else { fatalError() }
            container.model.relativeTo = unit
            tableView.shouldReload = true
            navigationItem.rightBarButtonItem?.isEnabled = container.model.valid
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}
