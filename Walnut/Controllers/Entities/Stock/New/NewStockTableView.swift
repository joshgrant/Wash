//
//  NewStockTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

// TODO: Disable state machine if boolean is true

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
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard let editCell = cell as? TextEditCell else { return }
        editCell.textField.resignFirstResponder()
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(model: newStockModel),
            makeValueTypeSection(model: newStockModel),
            makeStateMachineSection(model: newStockModel)
        ])
    }
    
    func makeInfoSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .title,
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
        let models: [TableViewCellModel] = ValueType.allCases.map { type in
            CheckmarkCellModel(
                selectionIdentifier: .valueType(type: type),
                title: type.description,
                checked: type == model.stockType)
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
                title: "Uses state machine".localized,
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
        if indexPath.section == 0 && indexPath.row == 0
        {
            guard let textCell = cell as? TextEditCell else { return }
            textCell.textField.becomeFirstResponder()
        }
    }
}
