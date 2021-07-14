//
//  CurrentIdealNumericTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class CurrentIdealNumericTableView: TableView
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
            makeGoalSection(newStockModel: newStockModel)
        ])
    }
    
    private func makeGoalSection(newStockModel: NewStockModel) -> TableViewSection
    {
        var postfix: String?
        
        if newStockModel.stockType == .percent
        {
            postfix = "%"
        }
        else
        {
            postfix = newStockModel.unit?.abbreviation
        }
        
        let models: [TableViewCellModel] = [
            SliderRangeCellModel(
                selectionIdentifier: .current(type: newStockModel.stockType),
                title: "Current".localized,
                value: Float(newStockModel.currentDouble ?? 0),
                min: Float(newStockModel.minimum ?? 0),
                max: Float(newStockModel.maximum ?? 100),
                postfix: postfix,
                keyboardType: .decimalPad),
            SliderRangeCellModel(
                selectionIdentifier: .ideal(type: newStockModel.stockType),
                title: "Ideal".localized,
                value: Float(newStockModel.idealDouble ?? 0),
                min: Float(newStockModel.minimum ?? 0),
                max: Float(newStockModel.maximum ?? 100),
                postfix: postfix,
                keyboardType: .decimalPad)
        ]
        
        return TableViewSection(header: .goal, models: models)
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let sliderCell = cell as? SliderRangeCell
        {
            sliderCell.rightField.becomeFirstResponder()
        }
    }
}
