//
//  CurrentIdealBooleanTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol CurrentIdealBooleanTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeCurrentSection() -> TableViewSection
    func makeIdealSection() -> TableViewSection
}

class CurrentIdealBooleanTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var newStockModel: NewStockModel
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, newStockModel: NewStockModel)
    {
        self.stream = stream
        self.style = style
        self.newStockModel = newStockModel
    }
}

extension CurrentIdealBooleanTableViewContainer: CurrentIdealBooleanTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeCurrentSection(),
            makeIdealSection()
        ])
    }
    
    func makeCurrentSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            CheckmarkCellModel(
                selectionIdentifier: .currentBool(state: true),
                title: "True".localized,
                checked: newStockModel.currentBool ?? true),
            CheckmarkCellModel(
                selectionIdentifier: .currentBool(state: false),
                title: "False".localized,
                checked: !(newStockModel.currentBool ?? true))
        ]
        
        return TableViewSection(
            header: .current,
            models: models)
    }
    
    func makeIdealSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            CheckmarkCellModel(
                selectionIdentifier: .idealBool(state: true),
                title: "True".localized,
                checked: newStockModel.idealBool ?? true),
            CheckmarkCellModel(
                selectionIdentifier: .idealBool(state: false),
                title: "False".localized,
                checked: !(newStockModel.idealBool ?? true))
        ]
        
        return TableViewSection(
            header: .ideal,
            models: models)
    }
}
