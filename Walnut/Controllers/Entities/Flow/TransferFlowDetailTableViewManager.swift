//
//  TransferFlowDetailTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

//class TransferFlowDetailTableView: TableView
//{
//    // MARK: - Variables
//    
//    var flow: TransferFlow
//    
//    // MARK: - Initialization
//    
//    init(flow: TransferFlow, stream: Stream)
//    {
//        self.flow = flow
//        
//        let model = Self.makeModel(flow: flow, stream: stream)
//        
//        super.init(model: model, stream: stream)
//    }
//    
//    // MARK: - Functions
//    
//    static func makeModel(flow: TransferFlow, stream: Stream) -> TableViewModel
//    {
//        TableViewModel(sections: [
//            makeInfoSection(flow: flow, stream: stream),
//            makeEventsSection(flow: flow),
//            makeHistorySection(flow: flow)
//        ])
//    }
//    
//    // MARK: Info Section
//    
//    static func makeInfoSection(flow: TransferFlow, stream: Stream) -> TableViewSection
//    {
//        TableViewSection(
//            header: .info,
//            models: makeInfoSectionRows(flow: flow, stream: stream),
//            footer: "Adds a to-do button in the dashboard".localizedLowercase)
//    }
//    
//    static func makeInfoSectionRows(flow: TransferFlow, stream: Stream) -> [TableViewCellModel]
//    {
//        let titleEdit = TextEditCellModel(
//            text: flow.title,
//            placeholder: "Title".localized,
//            entity: flow,
//            stream: stream)
//        
//        let from = DetailCellModel(
//            title: "From".localized,
//            detail: flow.from?.title ?? "None".localized,
//            disclosure: true)
//        
//        let to = DetailCellModel(
//            title: "To".localized,
//            detail: flow.to?.title ?? "None".localized,
//            disclosure: true)
//        
//        let amount = DetailCellModel(
//            title: "Amount".localized,
//            detail: String(format: "%.2f", flow.amount),
//            disclosure: true)
//        
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .brief
//        formatter.collapsesLargestUnit = true
//        
//        let durationString = formatter.string(from: flow.duration) ?? "None".localized
//        
//        let duration = DetailCellModel(
//            title: "Duration".localized,
//            detail: durationString,
//            disclosure: true)
//        
//        let requiresUserCompletion = ToggleCellModel(
//            title: "Requires user completion".localized,
//            toggleState: flow.requiresUserCompletion)
//        
//        return [
//            titleEdit,
//            from,
//            to,
//            amount,
//            duration,
//            requiresUserCompletion
//        ]
//    }
//    
//    // MARK: Events Section
//    
//    static func makeEventsSection(flow: TransferFlow) -> TableViewSection
//    {
//        TableViewSection(
//            header: .events,
//            models: makeEventsRows(flow: flow))
//    }
//    
//    static func makeEventsRows(flow: TransferFlow) -> [TableViewCellModel]
//    {
//        let events: [Event] = flow.unwrapped(\TransferFlow.events)
//        return events.map { event in
//            let flowCount = event.flows?.count ?? 0
//            let flowsString = flowCount == 1 ? "flow" : "flows"
//            let detailString = "\(flowCount) \(flowsString)"
//
//            return DetailCellModel(title: event.title, detail: detailString, disclosure: true)
//        }
//    }
//    
//    // MARK: History Section
//    
//    static func makeHistorySection(flow: TransferFlow) -> TableViewSection
//    {
//        TableViewSection(
//            header: .history,
//            models: makeHistoryRows(flow: flow))
//    }
//    
//    static func makeHistoryRows(flow: TransferFlow) -> [TableViewCellModel]
//    {
//        let histories: [History] = flow.unwrapped(\TransferFlow.history)
//        return histories.map { history in
//            let dateString = history.date!.format(with: .historyCellFormatter)
//            var detailString: String = ""
//            
//            if let value = history.valueSource?.amountOfStock?.currentValue as? Double
//            {
//                detailString = String(format: "%.2f", value)
//            }
//            else
//            {
//                assertionFailure("Failed to get the value")
//            }
//            
//            return DetailCellModel(
//                title: dateString,
//                detail: detailString,
//                disclosure: true)
//        }
//    }
//}
