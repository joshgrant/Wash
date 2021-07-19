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
        
        let minDetail: String
        let maxDetail: String
        
        if let min = model.minimum
        {
            minDetail = String(format: "%i", Int(min))
        }
        else
        {
            minDetail = ""
        }
        
        if let max = model.maximum
        {
            maxDetail = String(format: "%i", Int(max))
        }
        else
        {
            maxDetail = ""
        }
        
        let models: [TableViewCellModel] = [
            RightEditCellModel(
                selectionIdentifier: .minimum,
                title: "Minimum".localized,
                detail: minDetail,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: model),
            RightEditCellModel(
                selectionIdentifier: .maximum,
                title: "Maximum".localized,
                detail: maxDetail,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: model)
        ]
        
        return TableViewSection(header: .constraints, models: models)
    }
}
