//
//  IdealDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

protocol IdealDetailTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeHistorySection() -> TableViewSection
}

class IdealDetailTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var model: TableViewModel
    var stream: Stream
    var style: UITableView.Style
    var stock: Stock
    
    // MARK: - Initialization
    
    init(model: TableViewModel, stream: Stream, style: UITableView.Style, stock: Stock)
    {
        self.model = model
        self.stream = stream
        self.style = style
        self.stock = stock
    }
}

extension IdealDetailTableViewContainer: IdealDetailTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeHistorySection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        var models: [TableViewCellModel] = []
        var keyboardType: UIKeyboardType = .decimalPad
        
        if stock.valueType == .integer || stock.valueType == .percent
        {
            keyboardType = .numberPad
        }
        
        if stock.valueType == .decimal || stock.valueType == .integer
        {
            models = [
                // TODO: Should have the state machine here as well (to set ideal state machine value)
                TextEditCellModel(
                    selectionIdentifier: .ideal(type: stock.valueType),
                    text: stock.idealDescription,
                    placeholder: "Ideal value".localized,
                    entity: stock,
                    keyboardType: keyboardType)
            ]
        }
        else
        {
            models = [
                // TODO: Shouldn't be a toggle, but rather a multiple choice
                ToggleCellModel(
                    selectionIdentifier: .ideal(type: .boolean),
                    title: "Ideal value".localized,
                    toggleState: stock.idealValue < 1)
            ]
        }
        
        return TableViewSection(
            header: .ideal,
            models: models)
    }
    
    func makeHistorySection() -> TableViewSection
    {
        TableViewSection(models: [])
    }
}

class IdealDetailTableView: TableView<IdealDetailTableViewContainer>
{
    
}
