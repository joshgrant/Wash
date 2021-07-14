//
//  NewStockTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

public enum NewStockType: CaseIterable, CustomStringConvertible
{
    case boolean
    case integer
    case decimal
    case percent
    
    public var description: String
    {
        switch self
        {
        case .boolean:
            return "Boolean".localized
        case .integer:
            return "Integer".localized
        case .decimal:
            return "Decimal".localized
        case .percent:
            return "Percent".localized
        }
    }
}

class NewStockTableView: TableView
{
    var title: String?
    var unit: Unit?
    var stockType = NewStockType.boolean
    var isStateMachine: Bool = false
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeValueTypeSection(),
            makeStateMachineSection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: title,
                placeholder: "Title".localized,
                entity: nil),
            DetailCellModel(
                selectionIdentifier: .newStockUnit,
                title: "Unit".localized,
                detail: unit?.title ?? "None".localized,
                disclosure: true)
            
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    func makeValueTypeSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = NewStockType.allCases.map { type in
            CheckmarkCellModel(
                selectionIdentifier: .newStockType(type: type),
                title: type.description,
                checked: type == stockType)
        }
        
        return TableViewSection(
            header: .valueType,
            models: models)
    }
    
    func makeStateMachineSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            ToggleCellModel(
                selectionIdentifier: .stateMachine,
                title: "Uses state machine".localized,
                toggleState: isStateMachine)
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
