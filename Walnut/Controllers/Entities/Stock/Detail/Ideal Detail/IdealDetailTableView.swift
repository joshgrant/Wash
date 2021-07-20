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
    func makeTableView() -> TableView<IdealDetailTableViewContainer>
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeHistorySection() -> TableViewSection
}

class IdealDetailTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var stock: Stock
    
    lazy var model = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, stock: Stock)
    {
        self.stream = stream
        self.style = style
        self.stock = stock
    }
}

extension IdealDetailTableViewContainer: IdealDetailTableViewFactory
{
    func makeTableView() -> TableView<IdealDetailTableViewContainer>
    {
        .init(container: self)
    }
    
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
                    keyboardType: keyboardType,
                    stream: stream)
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
