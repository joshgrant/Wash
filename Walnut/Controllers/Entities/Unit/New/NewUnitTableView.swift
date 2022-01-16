//
//  NewUnitTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit
import Core

protocol NewUnitTableViewFactory: Factory
{
    func makeTableView() -> NewUnitTableView
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
}

class NewUnitTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var newUnitModel: NewUnitModel
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, newUnitModel: NewUnitModel)
    {
        self.stream = stream
        self.style = style
        self.newUnitModel = newUnitModel
    }
}

extension NewUnitTableViewContainer: NewUnitTableViewFactory
{
    func makeTableView() -> NewUnitTableView
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        var models: [TableViewCellModel] = [
            // Name
            // Symbol
            // Base Unit
            // Relative To
            RightEditCellModel(
                selectionIdentifier: .newUnitName,
                title: "Name".localized,
                detail: newUnitModel.title,
                detailPostfix: nil,
                keyboardType: .default,
                newStockModel: nil,
                stream: stream),
            RightEditCellModel(
                selectionIdentifier: .newUnitSymbol,
                title: "Symbol".localized,
                detail: newUnitModel.symbol,
                detailPostfix: nil,
                keyboardType: .default,
                newStockModel: nil,
                stream: stream),
            ToggleCellModel(
                selectionIdentifier: .baseUnit(isOn: newUnitModel.isBaseUnit),
                title: "Base unit",
                toggleState: newUnitModel.isBaseUnit,
                stream: stream)
        ]
        
        if !newUnitModel.isBaseUnit
        {
            models.append(DetailCellModel(
                            selectionIdentifier: .relativeTo,
                            title: "Relative to".localized,
                            detail: newUnitModel.relativeTo?.title ?? "None".localized,
                            disclosure: true))
        }
        
        return TableViewSection(
            header: .info,
            models: models)
    }
}

class NewUnitTableView: TableView<NewUnitTableViewContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    required init(container: NewUnitTableViewContainer)
    {
        super.init(container: container)
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Model
    
    func reloadForToggle(message: ToggleCellMessage)
    {
        reload(shouldReloadTableView: false)
        
        beginUpdates()
        
        if message.state
        {
            // This reloads the toggle cell so it's still connected to the model
            deleteRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }
        else
        {
            insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }
        
        endUpdates()
    }
}

extension NewUnitTableView: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as RightEditCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        switch message.selectionIdentifier
        {
        case .newUnitName:
            guard message.editType == .dismiss else { return }
            let nextCellIndexPath = IndexPath(row: 1, section: 0)
            guard let cell = cellForRow(at: nextCellIndexPath) as? RightEditCell else { return }
            cell.rightField.becomeFirstResponder()
        default:
            break
        }
    }
}
