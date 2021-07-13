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
        if stock.uniqueID == ContextPopulator.sinkId || stock.uniqueID == ContextPopulator.sourceId
        {
            return makeSinkSourceInfoSectionModels(stock: stock)
        }
        else
        {
            return makeDefaultInfoSectionModels(stock: stock)
        }
    }
    
    private func makeSinkSourceInfoSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        [
            TextCellModel(
                selectionIdentifier: .title,
                title: stock.title,
                disclosureIndicator: false),
            DetailCellModel(
                selectionIdentifier: .infinity,
                title: "Value".localized,
                detail: "Infinity".localized,
                disclosure: false)
        ]
    }
    
    private func makeDefaultInfoSectionModels(stock: Stock) -> [TableViewCellModel]
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
                selectionIdentifier: .minimum,
                title: "Minimum".localized,
                detail: stock.minimumDescription,
                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .maximum,
                title: "Maximum".localized,
                detail: stock.maximumDescription,
                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .current(type: stock.amountType),
                title: "Current".localized,
                detail: stock.currentDescription,
                disclosure: true), // TODO: Subtitle
            DetailCellModel(
                selectionIdentifier: .ideal(type: stock.amountType),
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
    
    func makeInflowSection(stock: Stock) -> TableViewSection?
    {
        let models = makeInflowSectionModels(stock: stock)
        
        if models.count == 0 { return nil }
        
        return TableViewSection(
            header: InflowsHeaderViewModel(),
            models: models)
    }
    
    func makeInflowSectionModels(stock: Stock) -> [TableViewCellModel]
    {
        let inflows = stock.unwrappedInflows
        return inflows.map { flow in
            
            guard let flow = flow as? TransferFlow else
            {
                fatalError("Can stocks have process flows as well?")
            }
            
            return FlowDetailCellModel(
                selectionIdentifier: .inflow(flow: flow),
                title: flow.title,
                from: flow.from?.title ?? "None".localized,
                to: flow.to?.title ?? "None".localized,
                detail: String(format: "%.2f", flow.amount))
        }
    }
    
    // MARK: Outflows
    
    func makeOutflowSection(stock: Stock) -> TableViewSection?
    {
        let models = makeOutflowSectionModels(stock: stock)
        
        if models.count == 0 { return nil }
        
        return TableViewSection(
            header: OutflowsHeaderViewModel(),
            models: models)
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
