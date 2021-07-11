//
//  TransferFlowDetailTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class TransferFlowDetailTableView: TableView
{
    // MARK: - Variables

    var flow: TransferFlow

    // MARK: - Initialization

    init(flow: TransferFlow)
    {
        self.flow = flow
        super.init()
    }

    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(flow: flow),
            makeEventsSection(flow: flow),
            makeHistorySection(flow: flow)
        ])
    }

    // MARK: Info Section

    func makeInfoSection(flow: TransferFlow) -> TableViewSection
    {
        TableViewSection(
            header: .info,
            models: makeInfoSectionRows(flow: flow),
            footer: "Adds a to-do button in the dashboard".localized)
    }

    func makeInfoSectionRows(flow: TransferFlow) -> [TableViewCellModel]
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

    func makeEventsSection(flow: TransferFlow) -> TableViewSection
    {
        TableViewSection(
            header: .events,
            models: makeEventsRows(flow: flow))
    }

    func makeEventsRows(flow: TransferFlow) -> [TableViewCellModel]
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

    func makeHistorySection(flow: TransferFlow) -> TableViewSection
    {
        TableViewSection(
            header: .history,
            models: makeHistoryRows(flow: flow))
    }

    func makeHistoryRows(flow: TransferFlow) -> [TableViewCellModel]
    {
        let histories: [History] = flow.unwrapped(\TransferFlow.history)
        return histories.map { history in
            let dateString = history.date!.format(with: .historyCellFormatter)
            var detailString: String = ""

            if let value = history.valueSource?.amountOfStock?.currentValue as? Double
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
