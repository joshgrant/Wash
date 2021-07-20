//
//  NewUnitTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol NewUnitTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
}

class NewUnitTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var model: TableViewModel
    var stream: Stream
    var style: UITableView.Style
    var newUnitModel: NewUnitModel
    
    // MARK: - Initialization
    
    init(model: TableViewModel, stream: Stream, style: UITableView.Style, newUnitModel: NewUnitModel)
    {
        self.model = model
        self.stream = stream
        self.style = style
        self.newUnitModel = newUnitModel
    }
}

extension NewUnitTableViewContainer: NewUnitTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(model: newUnitModel)
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
                detail: model.title,
                detailPostfix: nil,
                keyboardType: .default,
                newStockModel: nil),
            RightEditCellModel(
                selectionIdentifier: .newUnitSymbol,
                title: "Symbol".localized,
                detail: model.symbol,
                detailPostfix: nil,
                keyboardType: .default,
                newStockModel: nil),
            ToggleCellModel(
                selectionIdentifier: .baseUnit(isOn: model.isBaseUnit),
                title: "Base unit",
                toggleState: model.isBaseUnit)
        ]
        
        if !model.isBaseUnit
        {
            models.append(DetailCellModel(
                            selectionIdentifier: .relativeTo,
                            title: "Relative to".localized,
                            detail: model.relativeTo?.title ?? "None".localized,
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
