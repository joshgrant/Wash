//
//  TransferFlowDetailTableViewManager+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

extension TableViewData
{
    static func transferFlowDetail(flow: TransferFlow, stream: Stream) -> TableViewData
    {
        let sections: [TableViewSection] = [
            .info(flow: flow, stream: stream),
            .events(flow: flow),
            .history(flow: flow)
        ]
        return TableViewData(sections: sections)
    }
}

extension TableViewSection
{
    static func info(flow: TransferFlow, stream: Stream) -> TableViewSection
    {
        let rows: [TableViewRow] = [
            .title(flow: flow, stream: stream),
            .from(flow: flow),
            .to(flow: flow),
            .amount(flow: flow),
            .duration(flow: flow),
            .requiresUserCompletion(flow: flow)
        ]
        
        let footer = "Adds a to-do button in the dashboard".localized
        
        return TableViewSection(
            type: .info,
            header: .info,
            rows: rows,
            footer: footer)
    }
    
    static func events(flow: TransferFlow) -> TableViewSection
    {
        let events: [Event] = flow.unwrapped(\TransferFlow.events)
        let rows = events.map {
            TableViewRow.event($0)
        }
        
        return TableViewSection(
            type: .events,
            header: .events,
            rows: rows)
    }
    
    static func history(flow: TransferFlow) -> TableViewSection
    {
        let history: [History] = flow.unwrapped(\TransferFlow.history)
        let rows = history.map {
            TableViewRow.history($0)
        }
        
        return TableViewSection(
            type: .history,
            header: .history,
            rows: rows)
    }
}

extension TableViewRow
{
    // MARK: - Info section
    
    static func title(flow: TransferFlow, stream: Stream) -> TableViewRow
    {
        let model = TextEditCellModel.title(
            flow: flow,
            stream: stream)
        
        return TableViewRow(
            type: .title,
            model: model)
    }
    
    static func from(flow: TransferFlow) -> TableViewRow
    {
        let model = DetailCellModel.from(flow: flow)
        
        return TableViewRow(
            type: .from,
            model: model)
    }
    
    static func to(flow: TransferFlow) -> TableViewRow
    {
        let model = DetailCellModel.to(flow: flow)
        
        return TableViewRow(
            type: .to,
            model: model)
    }
    
    static func amount(flow: TransferFlow) -> TableViewRow
    {
        let model = DetailCellModel.amount(flow: flow)
        
        return TableViewRow(
            type: .amount,
            model: model)
    }
    
    static func duration(flow: TransferFlow) -> TableViewRow
    {
        let model = DetailCellModel.duration(flow: flow)
        
        return TableViewRow(
            type: .duration,
            model: model)
    }
    
    static func requiresUserCompletion(flow: TransferFlow) -> TableViewRow
    {
        let model = ToggleCellModel.requiresUserCompletion(flow: flow)
        
        return TableViewRow(
            type: .requiresUserCompletion,
            model: model)
    }
    
    // MARK: - Events
    
    static func event(_ event: Event) -> TableViewRow
    {
        let model = DetailCellModel.eventDetail(event)
        
        return TableViewRow(
            type: .event,
            model: model)
    }
    
    // MARK: - History
    
    static func history(_ history: History) -> TableViewRow
    {
        let model = TextCellModel.history(history)
        
        return TableViewRow(
            type: .history,
            model: model)
    }
}

extension TextEditCellModel
{
    static func title(flow: TransferFlow, stream: Stream) -> TextEditCellModel
    {
        TextEditCellModel(
            text: flow.title,
            placeholder: "Title".localized,
            entity: flow,
            stream: stream)
    }
}

extension DetailCellModel
{
    static func from(flow: TransferFlow) -> DetailCellModel
    {
        DetailCellModel(
            title: "From".localized,
            detail: flow.from?.title ?? "None".localized,
            disclosure: true)
    }
    
    static func to(flow: TransferFlow) -> DetailCellModel
    {
        DetailCellModel(
            title: "To".localized,
            detail: flow.to?.title ?? "None".localized,
            disclosure: true)
    }
    
    static func amount(flow: TransferFlow) -> DetailCellModel
    {
        let amount = String(format: "%.2f", flow.amount)
        
        return DetailCellModel(
            title: "Amount".localized,
            detail: amount,
            disclosure: true)
    }
    
    static func duration(flow: TransferFlow) -> DetailCellModel
    {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        let duration = formatter.string(for: flow.duration)!
        
        return DetailCellModel(
            title: "Duration".localized,
            detail: duration,
            disclosure: true)
    }
    
    static func eventDetail(_ event: Event) -> DetailCellModel
    {
        let flowCount = event.flows?.count ?? 0
        let flowPlural = flowCount == 1 ? "flow" : "flows"
        let flowCountString = "\(flowCount) \(flowPlural)".localized
        
        return DetailCellModel(
            title: event.title,
            detail: flowCountString,
            disclosure: true)
    }
}

extension TextCellModel
{
    static func history(_ history: History) -> TextCellModel
    {
        let dateString = history.date!.format(with: .historyCellFormatter)
        return TextCellModel(title: dateString, disclosureIndicator: true)
    }
}

extension ToggleCellModel
{
    static func requiresUserCompletion(flow: TransferFlow) -> ToggleCellModel
    {
        ToggleCellModel(
            title: "Require user completion".localized,
            toggleState: flow.requiresUserCompletion)
    }
}

extension TableHeaderViewModel
{
    static let info = TableHeaderViewModel(title: "Info".localized)
    static let events = TableHeaderViewModel(title: "Events".localized)
    static let history = TableHeaderViewModel(title: "History".localized)
}
