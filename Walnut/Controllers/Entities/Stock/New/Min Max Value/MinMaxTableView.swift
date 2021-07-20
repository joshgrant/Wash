//
//  MinMaxTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol MinMaxTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeConstraintsSection() -> TableViewSection
}

class MinMaxTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    var model: TableViewModel
    var stream: Stream
    var style: UITableView.Style
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, model: TableViewModel, stream: Stream, style: UITableView.Style)
    {
        self.newStockModel = newStockModel
        self.model = model
        self.stream = stream
        self.style = style
    }
}

extension MinMaxTableViewContainer: MinMaxTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeConstraintsSection()
        ])
    }
    
    func makeConstraintsSection() -> TableViewSection
    {
        let postfix: String? = newStockModel.unit?.abbreviation
        
        let minDetail: String
        let maxDetail: String
        
        if let min = newStockModel.minimum
        {
            minDetail = String(format: "%i", Int(min))
        }
        else
        {
            minDetail = ""
        }
        
        if let max = newStockModel.maximum
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
                newStockModel: newStockModel),
            RightEditCellModel(
                selectionIdentifier: .maximum,
                title: "Maximum".localized,
                detail: maxDetail,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: newStockModel)
        ]
        
        return TableViewSection(header: .constraints, models: models)
    }
}
