//
//  CurrentIdealNumericTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol CurrentIdealNumericTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeGoalSection() -> TableViewSection
}

class CurrentIdealNumericTableViewContainer: TableViewDependencyContainer
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

extension CurrentIdealNumericTableViewContainer: CurrentIdealNumericTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeGoalSection()
        ])
    }
    
    func makeGoalSection() -> TableViewSection
    {
        var postfix: String?
        var min: Float = 0
        var max: Float = 100
        
        if newStockModel.stockType == .percent
        {
            postfix = "%"
        }
        else
        {
            min = Float(newStockModel.minimum ?? 0)
            max = Float(newStockModel.maximum ?? 0)
            
            postfix = newStockModel.unit?.abbreviation
        }
        
        let models: [TableViewCellModel] = [
            SliderRangeCellModel(
                selectionIdentifier: .current(type: newStockModel.stockType),
                title: "Current".localized,
                value: Float(newStockModel.currentDouble ?? 0),
                min: min,
                max: max,
                postfix: postfix,
                keyboardType: .decimalPad),
            SliderRangeCellModel(
                selectionIdentifier: .ideal(type: newStockModel.stockType),
                title: "Ideal".localized,
                value: Float(newStockModel.idealDouble ?? 0),
                min: min,
                max: max,
                postfix: postfix,
                keyboardType: .decimalPad)
        ]
        
        return TableViewSection(header: .goal, models: models)
    }
}

class CurrentIdealNumericTableView: TableView<CurrentIdealNumericTableViewContainer>
{
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
