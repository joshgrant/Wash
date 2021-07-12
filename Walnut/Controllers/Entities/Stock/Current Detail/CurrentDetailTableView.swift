//
//  CurrentDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation

class CurrentDetailTableView: TableView
{
    // MARK: - Variables
    
    var stock: Stock
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        super.init()
    }
    
    // MARK: - Models
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeCurrentSection(stock: stock),
            makeChartSection(stock: stock),
            makeHistorySection(stock: stock)
        ])
    }
    
    // TODO: Configure Ideal and Current table views so that
    // we don't have to make this weird model stuff
    
    func makeCurrentSection(stock: Stock) -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            // Current value
            // State machine value (if applicable)
            TextEditCellModel(
                selectionIdentifier: .current(type: stock.amountType),
                text: stock.currentDescription,
                placeholder: "Current value".localized,
                entity: stock,
                keyboardType: .numberPad)
        ]
        
        return TableViewSection(
            header: .current,
            models: models)
    }
    
    func makeChartSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(models: [])
    }
    
    func makeHistorySection(stock: Stock) -> TableViewSection
    {
        let history: [History] = stock.unwrapped(\Stock.history)
        
        let models = history.map { history in
            FlowDetailCellModel(
                selectionIdentifier: .history(history: history),
                title: history.date!.format(with: .historyCellFormatter),
                // TODO: The history needs to know if the stock lost value, or if it gained it
                // it also needs to know where the value came from/went to
                from: "Error",
                to: "Error",
                detail: history.valueDescription)
        }
        
        return TableViewSection(models: models)
    }
}
