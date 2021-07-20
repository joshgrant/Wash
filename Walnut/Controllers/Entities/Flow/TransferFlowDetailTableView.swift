//
//  TransferFlowDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol TransferFlowDetailTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeEventsSection() -> TableViewSection
    func makeHistorySection() -> TableViewSection
}

class TransferFlowDetailTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var flow: TransferFlow
    
    lazy var model = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, flow: TransferFlow)
    {
        self.stream = stream
        self.style = style
        self.flow = flow
    }
}

extension TransferFlowDetailTableViewContainer: TransferFlowDetailTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeEventsSection(),
            makeHistorySection()
        ])
    }
    
    // MARK: Info Section
    
    func makeInfoSection() -> TableViewSection
    {
        TableViewSection(
            header: .info,
            models: makeInfoSectionRows(),
            footer: "Adds a to-do button in the dashboard".localized)
    }
    
    func makeInfoSectionRows() -> [TableViewCellModel]
    {
        let titleEdit = TextEditCellModel(
            selectionIdentifier: .title,
            text: flow.title,
            placeholder: "Title".localized,
            entity: flow,
            stream: stream)
        
        let from = DetailCellModel(
            selectionIdentifier: .fromStock(stock: flow.from),
            title: "From".localized,
            detail: flow.from?.title ?? "None".localized,
            disclosure: true)
        
        let to = DetailCellModel(
            selectionIdentifier: .toStock(stock: flow.to),
            title: "To".localized,
            detail: flow.to?.title ?? "None".localized,
            disclosure: true)
        
        let amount = DetailCellModel(
            selectionIdentifier: .flowAmount,
            title: "Amount".localized,
            detail: String(format: "%.2f", flow.amount),
            disclosure: true)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.collapsesLargestUnit = true
        
        let durationString = formatter.string(from: flow.duration) ?? "None".localized
        
        let duration = DetailCellModel(
            selectionIdentifier: .flowDuration,
            title: "Duration".localized,
            detail: durationString,
            disclosure: true)
        
        let requiresUserCompletion = ToggleCellModel(
            selectionIdentifier: .requiresUserCompletion(state: flow.requiresUserCompletion),
            title: "Requires user completion".localized,
            toggleState: flow.requiresUserCompletion)
        
        return [
            titleEdit,
            from,
            to,
            amount,
            duration,
            requiresUserCompletion
        ]
    }
    
    // MARK: Events Section
    
    func makeEventsSection() -> TableViewSection
    {
        TableViewSection(
            header: .events,
            models: makeEventsRows())
    }
    
    func makeEventsRows() -> [TableViewCellModel]
    {
        let events: [Event] = flow.unwrapped(\TransferFlow.events)
        return events.map { event in
            let flowCount = event.flows?.count ?? 0
            let flowsString = flowCount == 1 ? "flow" : "flows"
            let detailString = "\(flowCount) \(flowsString)"
            
            return DetailCellModel(
                selectionIdentifier: .event(event: event),
                title: event.title,
                detail: detailString,
                disclosure: true)
        }
    }
    
    // MARK: History Section
    
    func makeHistorySection() -> TableViewSection
    {
        TableViewSection(
            header: .history,
            models: makeHistoryRows())
    }
    
    func makeHistoryRows() -> [TableViewCellModel]
    {
        let histories: [History] = flow.unwrapped(\TransferFlow.history)
        return histories.map { history in
            let dateString = history.date!.format(with: .historyCellFormatter)
            var detailString: String = ""
            
            if let value = history.valueSource?.amountOfStock?.amountValue
            {
                detailString = String(format: "%.2f", value)
            }
            else
            {
                assertionFailure("Failed to get the value")
            }
            
            return DetailCellModel(
                selectionIdentifier: .history(history: history),
                title: dateString,
                detail: detailString,
                disclosure: true)
        }
    }
}

//class TransferFlowDetailTableView: TableView<TransferFlowDetailTableViewContainer>
//{
//}
