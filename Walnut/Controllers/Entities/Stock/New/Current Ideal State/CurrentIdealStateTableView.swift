//
//  CurrentIdealStateTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

protocol CurrentIdealStateTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeGoalSection() -> TableViewSection
}

class CurrentIdealStateTableViewContainer: TableViewContainer
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

extension CurrentIdealStateTableViewContainer: CurrentIdealStateTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeGoalSection()
        ])
    }
    
    func makeGoalSection() -> TableViewSection
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

//class CurrentIdealStateTableView: TableView<CurrentIdealStateTableViewContainer>
//{
//}
