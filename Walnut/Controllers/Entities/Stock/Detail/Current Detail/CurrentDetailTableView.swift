//
//  CurrentDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

protocol CurrentDetailTableViewFactory: Factory
{
    func makeTableView() -> TableView<CurrentDetailTableViewContainer>
    func makeModel() -> TableViewModel
    func makeCurrentSection() -> TableViewSection
    func makeChartSection() -> TableViewSection
    func makeHistorySection() -> TableViewSection
}

class CurrentDetailTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var stock: Stock
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, stock: Stock)
    {
        self.stream = stream
        self.style = style
        self.stock = stock
    }
}

extension CurrentDetailTableViewContainer: CurrentDetailTableViewFactory
{
    func makeTableView() -> TableView<CurrentDetailTableViewContainer>
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeCurrentSection(),
            makeChartSection(),
            makeHistorySection()
        ])
    }
    
    // TODO: Configure Ideal and Current table views so that
    // we don't have to make this weird model stuff
    
    func makeCurrentSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            // Current value
            // State machine value (if applicable)
            TextEditCellModel(
                selectionIdentifier: .current(type: stock.valueType),
                text: stock.currentDescription,
                placeholder: "Current value".localized,
                entity: stock,
                keyboardType: .numberPad,
                stream: stream)
        ]
        
        return TableViewSection(
            header: .current,
            models: models)
    }
    
    func makeChartSection() -> TableViewSection
    {
        TableViewSection(models: [])
    }
    
    func makeHistorySection() -> TableViewSection
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
