//
//  StockDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol StockDetailTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeStatesSection() -> TableViewSection?
    func makeInflowSection() -> TableViewSection?
    func makeOutflowSection() -> TableViewSection?
    func makeNotesSection() -> TableViewSection
}

class StockDetailTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var stock: Stock
    var stream: Stream
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(stock: Stock, stream: Stream, style: UITableView.Style)
    {
        self.stock = stock
        self.stream = stream
        self.style = style
    }
}

extension StockDetailTableViewContainer: StockDetailTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        let sections: [TableViewSection?] = [
            makeInfoSection(),
            makeStatesSection(),
            makeInflowSection(),
            makeOutflowSection(),
            makeNotesSection()
        ]
        
        return TableViewModel(
            sections: sections.compactMap { $0 })
    }
    
    func makeInfoSection() -> TableViewSection
    {
        TableViewSection(
            header: .info,
            models: makeInfoSectionModels())
    }
    
    func makeInfoSectionModels() -> [TableViewCellModel]
    {
        if stock.uniqueID == ContextPopulator.sinkId || stock.uniqueID == ContextPopulator.sourceId
        {
            return makeSinkSourceInfoSectionModels()
        }
        else
        {
            return makeDefaultInfoSectionModels()
        }
    }
    
    private func makeSinkSourceInfoSectionModels() -> [TableViewCellModel]
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
    
    private func makeDefaultInfoSectionModels() -> [TableViewCellModel]
    {
        [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: stock.title,
                placeholder: "Title".localized,
                entity: stock,
                stream: stream),
            DetailCellModel(
                selectionIdentifier: .type,
                title: "Type".localized,
                detail: stockTypeDetail(),
                disclosure: true),
            //            DetailCellModel(
            //                selectionIdentifier: .minimum,
            //                title: "Minimum".localized,
            //                detail: stock.minimumDescription,
            //                disclosure: true),
            //            DetailCellModel(
            //                selectionIdentifier: .maximum,
            //                title: "Maximum".localized,
            //                detail: stock.maximumDescription,
            //                disclosure: true),
            DetailCellModel(
                selectionIdentifier: .current(type: stock.valueType),
                title: "Current".localized,
                detail: stock.currentDescription,
                disclosure: true), // TODO: Subtitle
            //            DetailCellModel(
            //                selectionIdentifier: .ideal(type: stock.valueType),
            //                title: "Ideal".localized,
            //                detail: stock.idealDescription,
            //                disclosure: true),
            InfoCellModel(
                selectionIdentifier: .net,
                title: "Net".localized,
                detail: stock.netDescription) // FIXME: Wrong
        ]
    }
    
    func stockTypeDetail() -> String
    {
        var amountType: String = stock.valueType.description
        
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
    
    func makeStatesSection() -> TableViewSection?
    {
        // FIXME: Shouldn't always be nil
        return nil
    }
    
    // MARK: Inflows
    
    func makeInflowSection() -> TableViewSection?
    {
        let models = makeInflowSectionModels()
        
        if models.count == 0 { return nil }
        
        return TableViewSection(
            header: .inflows,
            models: models)
    }
    
    func makeInflowSectionModels() -> [TableViewCellModel]
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
    
    func makeOutflowSection() -> TableViewSection?
    {
        let models = makeOutflowSectionModels()
        
        if models.count == 0 { return nil }
        
        return TableViewSection(
            header: .outflows,
            models: models)
    }
    
    func makeOutflowSectionModels() -> [TableViewCellModel]
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
    
    func makeNotesSection() -> TableViewSection
    {
        TableViewSection(
            header: .notes,
            models: makeNoteSectionModels())
    }
    
    func makeNoteSectionModels() -> [TableViewCellModel]
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
