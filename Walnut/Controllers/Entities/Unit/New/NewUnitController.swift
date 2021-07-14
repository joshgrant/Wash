//
//  NewUnitController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class NewUnitController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var newUnitModel: NewUnitModel
    var tableView: NewUnitTableView
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        
        let newUnitModel = NewUnitModel()
        self.newUnitModel = newUnitModel
        
        tableView = NewUnitTableView(newUnitModel: newUnitModel)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        view.embed(tableView)
        
        let leftItem = UIBarButtonItem(systemItem: .cancel)
        leftItem.target = self
        leftItem.action = #selector(cancelDidTouchUpInside(_:))
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(systemItem: .save)
        rightItem.target = self
        rightItem.action = #selector(saveDidTouchUpInside(_:))
        rightItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightItem
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
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
        guard let context = context else { fatalError() }
        
        let unit = Unit(context: context)
        
        let symbol = Symbol(context: context)
        symbol.name = newUnitModel.title
        unit.symbolName = symbol
        
        unit.abbreviation = newUnitModel.symbol
        unit.isBase = newUnitModel.isBaseUnit
        unit.relativeTo = newUnitModel.relativeTo
        
        context.quickSave()
        
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
        newUnitModel.isBaseUnit = message.state
        navigationItem.rightBarButtonItem?.isEnabled = newUnitModel.valid
        tableView.reloadForToggle(message: message)
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        switch message.selectionIdentifier
        {
        case .newUnitName:
            newUnitModel.title = message.content
        case .newUnitSymbol:
            newUnitModel.symbol = message.content
        default:
            break
        }
        navigationItem.rightBarButtonItem?.isEnabled = newUnitModel.valid
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        let linkController = LinkSearchController(
            origin: .newUnit(id: id),
            entityType: Unit.self,
            context: context,
            hasAddButton: true)
        
        navigationController?.pushViewController(linkController, animated: true)
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        switch message.origin
        {
        case .newUnit(let id):
            guard id == self.id else { return }
            guard let unit = message.link as? Unit else { fatalError() }
            newUnitModel.relativeTo = unit
            tableView.shouldReload = true
            navigationItem.rightBarButtonItem?.isEnabled = newUnitModel.valid
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}
