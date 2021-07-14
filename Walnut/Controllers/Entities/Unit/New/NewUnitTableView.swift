//
//  NewUnitTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class NewUnitTableView: TableView
{
    // MARK: - Variables
    
    var id = UUID()
    var newUnitModel: NewUnitModel
    
    // MARK: - Initialization
    
    init(newUnitModel: NewUnitModel)
    {
        self.newUnitModel = newUnitModel
        super.init()
        subscribe(to: AppDelegate.shared.mainStream)
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(model: newUnitModel)
        ])
    }
    
    // TODO: Reload when toggling the cell...
    
    func makeInfoSection(model: NewUnitModel) -> TableViewSection
    {
        var models: [TableViewCellModel] = [
            // Name
            // Symbol
            // Base Unit
            // Relative To
            RightEditCellModel(
                selectionIdentifier: .newUnitName,
                title: "Name".localized,
                detail: model.title),
            RightEditCellModel(
                selectionIdentifier: .newUnitSymbol,
                title: "Symbol".localized,
                detail: model.symbol),
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
            let nextCellIndexPath = IndexPath(row: 1, section: 0)
            guard let cell = cellForRow(at: nextCellIndexPath) as? RightEditCell else { return }
            cell.rightField.becomeFirstResponder()
        default:
            break
        }
    }
}
