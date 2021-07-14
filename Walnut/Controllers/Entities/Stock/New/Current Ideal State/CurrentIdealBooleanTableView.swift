//
//  CurrentIdealBooleanTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class CurrentIdealBooleanTableView: TableView
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
            makeCurrentSection(model: newStockModel),
            makeIdealSection(model: newStockModel)
        ])
    }
    
    private func makeCurrentSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            CheckmarkCellModel(
                selectionIdentifier: .currentBool(state: true),
                title: "True".localized,
                checked: model.currentBool ?? true),
            CheckmarkCellModel(
                selectionIdentifier: .currentBool(state: false),
                title: "False".localized,
                checked: !(model.currentBool ?? true))
        ]
        
        return TableViewSection(
            header: .current,
            models: models)
    }
    
    private func makeIdealSection(model: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            CheckmarkCellModel(
                selectionIdentifier: .idealBool(state: true),
                title: "True".localized,
                checked: model.idealBool ?? true),
            CheckmarkCellModel(
                selectionIdentifier: .idealBool(state: false),
                title: "False".localized,
                checked: !(model.idealBool ?? true))
        ]
        
        return TableViewSection(
            header: .ideal,
            models: models)
    }
}
