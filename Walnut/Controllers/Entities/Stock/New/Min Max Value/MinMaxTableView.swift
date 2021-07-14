//
//  MinMaxTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class MinMaxTableView: TableView
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
        TableViewModel(sections: [
            makeConstraintsSection(model: newStockModel)
        ])
    }
    
    private func makeConstraintsSection(model: NewStockModel) -> TableViewSection
    {
        let postfix: String? = model.unit?.abbreviation
        
        let models: [TableViewCellModel] = [
            RightEditCellModel(
                selectionIdentifier: .minimum,
                title: "Minimum".localized,
                detail: model.minimum?.description,
                detailPostfix: postfix,
                keyboardType: .decimalPad),
            RightEditCellModel(
                selectionIdentifier: .maximum,
                title: "Maximum".localized,
                detail: model.maximum?.description,
                detailPostfix: postfix,
                keyboardType: .decimalPad)
        ]
        
        return TableViewSection(header: .constraints, models: models)
    }
}
