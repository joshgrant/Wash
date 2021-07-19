//
//  NewStockStateTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

// TODO: Keyboard avoiding (on all table views!)

class NewStockStateTableView: TableView
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
        var sections = newStockModel.states.map { state in
            makeStatesSection(state: state)
        }
        
        sections.insert(makeHeaderSection(), at: 0)
        sections.append(makeAddSection())
        
        return TableViewModel(sections: sections)
    }
    
    func addState(newStateModel: NewStateModel)
    {
        let section = makeStatesSection(state: newStateModel)
        model.sections.insert(section, at: model.sections.count - 1)
        model.sectionsUpdated() // FIXME: HACK!
        configure() // FIXME: HACK!
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
                entity: nil),
            RightEditCellModel(
                selectionIdentifier: .stateFrom(state: state),
                title: "From".localized,
                detail: from,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: nil),
            RightEditCellModel(
                selectionIdentifier: .stateTo(state: state),
                title: "To".localized,
                detail: to,
                detailPostfix: postfix,
                keyboardType: nil,
                newStockModel: nil)
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
