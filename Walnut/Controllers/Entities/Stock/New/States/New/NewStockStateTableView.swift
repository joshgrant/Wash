//
//  NewStockStateTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

// TODO: Keyboard avoiding (on all table views!)

protocol NewStockStateTableViewFactory: Factory
{
    func makeTableView() -> NewStockStateTableView
    func makeModel() -> TableViewModel
    func makeHeaderSection() -> TableViewSection
    func makeStatesSection(state: NewStateModel) -> TableViewSection
    func makeAddSection() -> TableViewSection
}

class NewStockStateTableViewContainer: TableViewContainer
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

extension NewStockStateTableViewContainer: NewStockStateTableViewFactory
{
    func makeTableView() -> NewStockStateTableView
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        var sections = newStockModel.states.map { state in
            makeStatesSection(state: state)
        }
        
        sections.insert(makeHeaderSection(), at: 0)
        sections.append(makeAddSection())
        
        return TableViewModel(sections: sections)
    }
    
    func makeHeaderSection() -> TableViewSection
    {
        TableViewSection(header: .stateMachine, models: [])
    }
    
    func makeStatesSection(state: NewStateModel) -> TableViewSection
    {
        var postfix: String?
        
        if newStockModel.stockType == .percent
        {
            postfix = "%".localized
        }
        else if let unit = newStockModel.unit, let abbreviation = unit.abbreviation
        {
            postfix = abbreviation
        }
        
        // TODO: Formatters everywhere
        let from: String? = {
            guard let from = state.from else { return nil }
            return String(format: "%i", Int(from))
        }()
        
        let to: String? = {
            guard let to = state.to else { return nil }
            return String(format: "%i", Int(to))
        }()
        
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .stateTitle(state: state),
                text: state.title,
                placeholder: "Title".localized,
                entity: nil,
                stream: stream),
            RightEditCellModel(
                selectionIdentifier: .stateFrom(state: state),
                title: "From".localized,
                detail: from,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: nil,
                stream: stream),
            RightEditCellModel(
                selectionIdentifier: .stateTo(state: state),
                title: "To".localized,
                detail: to,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: nil,
                stream: stream)
        ]
        
        return TableViewSection(models: models)
    }
    
    func makeAddSection() -> TableViewSection
    {
        return TableViewSection(models: [
            CenterActionCellModel(
                selectionIdentifier: .addState,
                title: "Add State".localized)
        ])
    }
}

class NewStockStateTableView: TableView<NewStockStateTableViewContainer>
{
    // MARK: - Functions
    
    // FIXME: Collection view diffing
    
    func addState(newStateModel: NewStateModel)
    {
        let section = container.makeStatesSection(state: newStateModel)
        container.model.sections.insert(section, at: container.model.sections.count - 1)
        container.model.sectionsUpdated() // FIXME
        configure() // FIXME
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        switch section
        {
        case 0: return 1
        default: return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        switch section
        {
        case 0: return 0
        default: return 10
        }
    }
}
