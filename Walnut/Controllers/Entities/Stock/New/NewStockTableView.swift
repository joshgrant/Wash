//
//  NewStockTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

class NewStockTableView: TableView
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel)
    {
        self.newStockModel = newStockModel
        super.init()
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        let sections: [TableViewSection] = [
            makeInfoSection(model: newStockModel),
            makeStateMachineSection(model: newStockModel),
            makeValueTypeSection(model: newStockModel),
        ]
        
        return TableViewModel(sections: sections)
    }
    
    func makeInfoSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .newStockName,
                text: model.title,
                placeholder: "Title".localized,
                entity: nil),
            DetailCellModel(
                selectionIdentifier: .newStockUnit,
                title: "Unit".localized,
                detail: model.unit?.title ?? "None".localized,
                disclosure: true)
            
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    func makeValueTypeSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = ValueType.allCases.compactMap { type in

            return CheckmarkCellModel(
                selectionIdentifier: .valueType(type: type),
                title: type.description,
                checked: type == model.stockType,
                enabled: !(type == .boolean && model.isStateMachine))
        }
        
        return TableViewSection(
            header: .valueType,
            models: models)
    }
    
    func makeStateMachineSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            ToggleCellModel(
                selectionIdentifier: .stateMachine,
                title: "State Machine".localized,
                toggleState: model.isStateMachine)
        ]
        
        return TableViewSection(
            header: .stateMachine,
            models: models)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath)
    {
        guard indexPath.section == 0 && indexPath.row == 0 else { return }
        guard let textCell = cell as? TextEditCell else { return }
        
        if let text = textCell.textField.text
        {
            if text.isEmpty
            {
                textCell.textField.becomeFirstResponder()
            }
        }
        else
        {
            textCell.textField.becomeFirstResponder()
        }
    }
}
