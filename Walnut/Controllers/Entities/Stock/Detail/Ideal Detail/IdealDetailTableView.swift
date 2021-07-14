//
//  IdealDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

class IdealDetailTableView: TableView
{
    // MARK: - Variables
    
    var stock: Stock
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        super.init()
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(stock: stock),
            makeHistorySection(stock: stock)
        ])
    }
    
    func makeInfoSection(stock: Stock) -> TableViewSection
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
    
    func makeHistorySection(stock: Stock) -> TableViewSection
    {
        TableViewSection(models: [])
    }
}
