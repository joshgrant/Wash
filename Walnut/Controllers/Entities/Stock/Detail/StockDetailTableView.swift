//
//  StockDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class StockDetailTableView: TableView
{
    // MARK: - Variables
    
    var stock: Stock
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        super.init()
    }
    
    // MARK: - Configuration
    
    override func makeModel() -> TableViewModel
    {
        let sections: [TableViewSection?] = [
            makeInfoSection(stock: stock),
            makeStatesSection(stock: stock),
            makeInflowSection(stock: stock),
            makeOutflowSection(stock: stock),
            makeEventsSection(stock: stock),
            makeNotesSection(stock: stock)
        ]
        
        return TableViewModel(
            sections: sections.compactMap { $0 })
    }
    
    // MARK: Info
    
    func makeInfoSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: .info,
            models: makeInfoSectionModels(stock: stock))
    }
    
    func makeInfoSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: stock.title,
                placeholder: "Title".localized,
                entity: stock),
            DetailCellModel(
                selectionIdentifier: .type,
                title: "Type".localized,
                detail: stockTypeDetail(stock: stock),
                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .dimension,
                title: "Dimension".localized,
                detail: stock.dimensionDescription,
                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .current,
                title: "Current".localized,
                detail: stock.currentDescription,
                disclosure: true), // TODO: Subtitle
            DetailCellModel(
                selectionIdentifier: .ideal,
                title: "Ideal".localized,
                detail: stock.idealDescription,
                disclosure: true),
            InfoCellModel(
                selectionIdentifier: .net,
                title: "Net".localized,
                detail: stock.netDescription) // FIXME: Wrong
        ]
    }
    
    func stockTypeDetail(stock: Stock) -> String
    {
        var amountType: String
        
        switch stock.amountType
        {
        case .boolean:
            amountType = "Boolean".localized
        case .integer:
            amountType = "Integer".localized
        case .decimal:
            amountType = "Decimal".localized
        }
        
        amountType += ", "
        
        switch stock.stateMachine
        {
        case true:
            amountType += "State Machine".localized
        case false:
            amountType += "Continuous".localized
        }
        
        return amountType
    }
    
    // MARK: States
    
    func makeStatesSection(stock: Stock) -> TableViewSection?
    {
        // FIXME: Shouldn't always be nil
        return nil
    }
    
    // MARK: Inflows
    
    func makeInflowSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: InflowsHeaderViewModel(),
            models: makeInflowSectionModels(stock: stock))
    }
    
    func makeInflowSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        stock
            .unwrappedInflows
            .map { flow in
                // FIXME: Wrong
                SubtitleDetailCellModel(
                    selectionIdentifier: .inflow(flow: flow),
                    title: flow.title,
                    subtitle: "AMOUNT???",
                    detail: "Some -> Some",
                    tall: true)
            }
    }
    
    // MARK: Outflows
    
    func makeOutflowSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: OutflowsHeaderViewModel(),
            models: makeOutflowSectionModels(stock: stock))
    }
    
    func makeOutflowSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        let outflows = stock.unwrappedOutflows
        return outflows.map { flow in
            
            guard let flow = flow as? TransferFlow else
            {
                fatalError("Can stocks have process flows as well?")
            }
            
            return FlowDetailCellModel(
                selectionIdentifier: .outflow(flow: flow),
                title: flow.title,
                from: flow.from?.title ?? "None".localized,
                to: flow.to?.title ?? "None".localized,
                detail: String(format: "%.2f", flow.amount))
        }
    }
    
    // MARK: Events
    
    func makeEventsSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: EventsHeaderViewModel(),
            models: makeEventSectionModels(stock: stock))
    }
    
    func makeEventSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        let events = stock.unwrappedEvents
        return events.map {
            let flowCount = $0.flows?.count ?? 0
            let flowSubtitle = "\(flowCount) flow\(flowCount == 1 ? "" : "s")"
            return DetailCellModel(
                selectionIdentifier: .event(event: $0),
                title: $0.title,
                detail: flowSubtitle,
                disclosure: true)
        }
    }
    
    // MARK: Notes
    
    func makeNotesSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: NotesHeaderViewModel(),
            models: makeNoteSectionModels(stock: stock))
    }
    
    func makeNoteSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        let notes: [Note] = stock.unwrapped(\Stock.notes)
        return notes.map {
            // TODO: Subtitle
            return DetailCellModel(
                selectionIdentifier: .note(note: $0),
                title: $0.title,
                detail: $0.firstLine ?? "",
                disclosure: true)
        }
    }
}
