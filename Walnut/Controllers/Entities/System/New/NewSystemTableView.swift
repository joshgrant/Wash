//
//  NewSystemTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/21/21.
//

import UIKit

protocol NewSystemTableviewFactory: Factory
{
    func makeTableView() -> NewSystemTableView
    func makeModel() -> TableViewModel
}

protocol NewSystemTableViewContainer: TableViewContainer
{
    var model: TableViewModel { get set }
    var stream: Stream { get set }
    var style: UITableView.Style { get set }
}

class NewSystemTableViewBuilder: NewSystemTableviewFactory & NewSystemTableViewContainer
{
    // MARK: - Variables
    
    var newSystemModel: NewSystemModel
    var stream: Stream
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(newSystemModel: NewSystemModel, stream: Stream, style: UITableView.Style)
    {
        self.newSystemModel = newSystemModel
        self.stream = stream
        self.style = style
    }
    
    // MARK: - Functions
    
    func makeTableView() -> NewSystemTableView
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        TableViewSection(header: .info, models: [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: newSystemModel.title,
                placeholder: "Title".localized,
                entity: nil,
                stream: stream)
        ])
    }
}

class NewSystemTableView: TableView<NewSystemTableViewBuilder>
{
    var titleCell: TextEditCell
    {
        let indexPath = IndexPath(row: 0, section: 0)
        return cellForRow(at: indexPath) as! TextEditCell
    }
}
