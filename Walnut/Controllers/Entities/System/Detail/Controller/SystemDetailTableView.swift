//
//  SystemDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol SystemDetailTableViewFactory: Factory
{
    func makeTableView() -> SystemDetailTableView
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeStockSection() -> TableViewSection
    func makeFlowSection() -> TableViewSection
    func makeEventSection() -> TableViewSection
    func makeNoteSection() -> TableViewSection
}

class SystemDetailTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var system: System
    var stream: Stream
    var style: UITableView.Style
    
    lazy var tableView: SystemDetailTableView = makeTableView() // Should the table view container or the controller hold this?
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(system: System, stream: Stream, style: UITableView.Style)
    {
        self.system = system
        self.stream = stream
        self.style = style
    }
}

extension SystemDetailTableViewContainer: SystemDetailTableViewFactory
{
    func makeTableView() -> SystemDetailTableView
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeStockSection(),
            makeFlowSection(),
            makeEventSection(),
            makeNoteSection()
        ])
    }
    
    // MARK: Info
    
    func makeInfoSection() -> TableViewSection
    {
        var models: [TableViewCellModel] = []
        
        models.append(TextEditCellModel(
                        selectionIdentifier: .title,
                        text: system.title,
                        placeholder: "Name".localized,
                        entity: system,
                        stream: stream))
        
        models.append(InfoCellModel(
                        selectionIdentifier: .systemIdeal,
                        title: "Ideal".localized,
                        detail: "\(system.percentIdeal)%"))
        
        let suggestedFlows: [Flow] = system.unwrapped(\System.suggestedFlows)
        if let flow = suggestedFlows.first
        {
            models.append(SuggestedFlowCellModel(
                            selectionIdentifier: .flow(flow: flow),
                            title: flow.title))
        }
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    // MARK: Stocks
    
    func makeStockSection() -> TableViewSection
    {
        let models = system.unwrappedStocks.map { stock in
            DetailCellModel(
                selectionIdentifier: .stock(stock: stock),
                title: stock.title,
                detail: stock.currentDescription,
                disclosure: true)
        }
        
        let headerContainer = StocksHeaderViewModelContainer(system: system, stream: stream)
        let header = headerContainer.makeHeaderViewModel()
        
        return TableViewSection(
            header: header,
            models: models)
    }
    
    // MARK: Flows
    
    func makeFlowSection() -> TableViewSection
    {
        let models = system.unwrappedFlows.map { flow in
            DetailCellModel(
                selectionIdentifier: .flow(flow: flow),
                title: flow.title,
                detail: "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: .systemDetailFlows,
            models: models)
    }
    
    // MARK: Events
    
    func makeEventSection() -> TableViewSection
    {
        let models = system.unwrappedEvents.map { event in
            DetailCellModel(
                selectionIdentifier: .event(event: event),
                title: event.title,
                detail: "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: .events,
            models: models)
    }
    
    // MARK: Notes
    
    func makeNoteSection() -> TableViewSection
    {
        let models = system.unwrappedNotes.map { note in
            DetailCellModel(
                selectionIdentifier: .note(note: note),
                title: note.title,
                detail: note.firstLine ?? "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: .notes,
            models: models)
    }
}

class SystemDetailTableView: TableView<SystemDetailTableViewContainer>
{
    // FIXME: This is a hack
    func titleCell() -> TextEditCell
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = cellForRow(at: indexPath)
        return cell as! TextEditCell
    }
    
    func makeTextCellFirstResponderIfEmpty()
    {
        let cell = titleCell()
        
        if cell.isEmpty
        {
            cell.textField.becomeFirstResponder()
        }
    }
}
