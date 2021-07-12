//
//  SystemDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class SystemDetailTableView: TableView
{
    // MARK: - Variables
    
    var system: System
    
    // MARK: - Initialization
    
    init(system: System)
    {
        self.system = system
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(system: system),
            makeStockSection(system: system),
            makeFlowSection(system: system),
            makeEventSection(system: system),
            makeNoteSection(system: system)
        ])
    }
    
    // MARK: Info
    
    func makeInfoSection(system: System) -> TableViewSection
    {
        var models: [TableViewCellModel] = []
        
        models.append(TextEditCellModel(
                        selectionIdentifier: .title,
                        text: system.title,
                        placeholder: "Name".localized,
                        entity: system))
        
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
    
    func makeStockSection(system: System) -> TableViewSection
    {
        let models = system.unwrappedStocks.map { stock in
            DetailCellModel(
                selectionIdentifier: .stock(stock: stock),
                title: stock.title,
                detail: stock.currentDescription,
                disclosure: true)
        }
        
        return TableViewSection(
            header: StocksHeaderViewModel(system: system),
            models: models)
    }
    
    // MARK: Flows
    
    func makeFlowSection(system: System) -> TableViewSection
    {
        let models = system.unwrappedFlows.map { flow in
            DetailCellModel(
                selectionIdentifier: .flow(flow: flow),
                title: flow.title,
                detail: "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: SystemDetailFlowsHeaderViewModel(),
            models: models)
    }
    
    // MARK: Events
    
    func makeEventSection(system: System) -> TableViewSection
    {
        let models = system.unwrappedEvents.map { event in
            DetailCellModel(
                selectionIdentifier: .event(event: event),
                title: event.title,
                detail: "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: EventsHeaderViewModel(),
            models: models)
    }
    
    // MARK: Notes
    
    func makeNoteSection(system: System) -> TableViewSection
    {
        let models = system.unwrappedNotes.map { note in
            DetailCellModel(
                selectionIdentifier: .note(note: note),
                title: note.title,
                detail: note.firstLine ?? "None",
                disclosure: true)
        }
        
        return TableViewSection(
            header: NotesHeaderViewModel(),
            models: models)
    }
    
    // MARK: - Utility
    
    private func titleCell() -> TextEditCell
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
