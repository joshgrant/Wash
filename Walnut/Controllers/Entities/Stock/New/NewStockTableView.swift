//
//  NewStockTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation
import UIKit

protocol NewStockTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeValueTypeSection() -> TableViewSection
    func makeStateMachineSection() -> TableViewSection
}

class NewStockTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    var stream: Stream
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, stream: Stream, style: UITableView.Style)
    {
        self.newStockModel = newStockModel
        self.stream = stream
        self.style = style
    }
}

extension NewStockTableViewContainer: NewStockTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        let sections: [TableViewSection] = [
            makeInfoSection(),
            makeStateMachineSection(),
            makeValueTypeSection(),
        ]
        
        return TableViewModel(sections: sections)
    }
    
    func makeInfoSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .newStockName,
                text: newStockModel.title,
                placeholder: "Title".localized,
                entity: nil,
                stream: stream),
            DetailCellModel(
                selectionIdentifier: .newStockUnit,
                title: "Unit".localized,
                detail: newStockModel.unit?.title ?? "None".localized,
                disclosure: true)
            
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    func makeValueTypeSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = ValueType.allCases.compactMap { type in
            
            return CheckmarkCellModel(
                selectionIdentifier: .valueType(type: type),
                title: type.description,
                checked: type == newStockModel.stockType,
                enabled: !(type == .boolean && newStockModel.isStateMachine))
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
                title: "State Machine".localized,
                toggleState: newStockModel.isStateMachine,
                stream: stream)
        ]
        
        return TableViewSection(
            header: .stateMachine,
            models: models)
    }
}

class NewStockTableView: TableView<NewStockTableViewContainer>
{
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
