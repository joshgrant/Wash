//
//  CurrentIdealStateTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class CurrentIdealStateTableView: TableView
{
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel)
    {
        self.newStockModel = newStockModel
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeGoalSection(newStockModel: newStockModel)
        ])
    }
    
    private func makeGoalSection(newStockModel: NewStockModel) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            DetailCellModel(
                selectionIdentifier: .currentState,
                title: "Current".localized,
                detail: newStockModel.currentState?.title ?? "None".localized,
                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .idealState,
                title: "Ideal".localized,
                detail: newStockModel.idealState?.title ?? "None".localized,
                disclosure: true)
        ]
        
        return TableViewSection(header: .goal, models: models)
    }
}
