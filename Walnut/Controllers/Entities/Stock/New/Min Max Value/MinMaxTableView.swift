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

class MinMaxTableViewContainer: TableViewContainer
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
                newStockModel: newStockModel,
                stream: stream),
            RightEditCellModel(
                selectionIdentifier: .maximum,
                title: "Maximum".localized,
                detail: maxDetail,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: newStockModel,
                stream: stream)
        ]
        
        return TableViewSection(header: .constraints, models: models)
    }
}
