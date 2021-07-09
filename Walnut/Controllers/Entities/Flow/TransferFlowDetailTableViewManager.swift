//
//  TransferFlowDetailTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailTableViewManager: NSObject
{
    // MARK: - Variables
    
    var headerModels: [TableHeaderViewModel]
    var cellModels: [[TableViewCellModel]]
    
    var tableView: UITableView
    
    weak var stream: Stream?
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, stream: Stream)
    {
        self.tableView = UITableView(
            frame: .zero,
            style: .grouped)
        
        self.headerModels = Self.makeHeaderModels()
        self.cellModels = Self.makeCellModels(flow: flow, stream: stream)
        
        super.init()
        
        Self.cellModelTypes().forEach
        {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Factory
    
    static func cellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            TextEditCellModel.self,
            DetailCellModel.self,
            ToggleCellModel.self
        ]
    }
    
    static func makeHeaderModels() -> [TableHeaderViewModel]
    {
        [
            InfoHeaderViewModel(),
            TableHeaderViewModel(title: "Events".localized),
            TableHeaderViewModel(title: "History".localized)
        ]
    }
    
    static func makeCellModels(flow: TransferFlow, stream: Stream) -> [[TableViewCellModel]]
    {
        [
            makeInfoCellModels(flow: flow, stream: stream),
            makeEventsCellModels(flow: flow),
            makeHistoryCellModels(flow: flow)
        ]
    }
    
    static func makeInfoCellModels(flow: TransferFlow, stream: Stream) -> [TableViewCellModel]
    {
        return [
            TextEditCellModel(
                text: flow.title,
                placeholder: "Title".localized,
                entity: flow,
                stream: stream),
            DetailCellModel(
                title: "From".localized,
                detail: "USD".localized, // TODO: Replace
                disclosure: true),
            DetailCellModel(
                title: "To".localized,
                detail: "Out".localized, // TODO: Replace
                disclosure: true),
            DetailCellModel(
                title: "Amount".localized,
                detail: "9.99", // TODO: Replace
                disclosure: false),
            DetailCellModel(
                title: "Duration".localized,
                detail: "None".localized, // TODO: Replace
                disclosure: false),
            ToggleCellModel(
                title: "Require user completion".localized,
                toggleState: flow.requiresUserCompletion)
        ]
    }
    
    static func makeEventsCellModels(flow: TransferFlow) -> [TableViewCellModel]
    {
        let events: [Event] = flow.unwrapped(\TransferFlow.events)
        return events.map { event in
            
            let flowCount = event.flows?.count ?? 0
            let flowCountString = "\(flowCount) flows".localized // TODO: Plural
            
            return DetailCellModel(
                title: event.title,
                detail: flowCountString,
                disclosure: true)
        }
    }
    
    static func makeHistoryCellModels(flow: TransferFlow) -> [TableViewCellModel]
    {
        let history: [History] = flow.unwrapped(\TransferFlow.history)
        return history.map { history in
            // TODO: Fix the force unwrap
            let dateString = history.date!.format(with: .historyCellFormatter)
            return TextCellModel(title: dateString, disclosureIndicator: true)
        }
    }
}

extension TransferFlowDetailTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let model = headerModels[section]
        return TableHeaderView(model: model)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "Adds a to-do button in the dashboard".localized
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = TableViewSelectionMessage(
            tableView: tableView,
            indexPath: indexPath,
            token: .transferFlowDetail)
        
        let stream = stream ?? AppDelegate.shared.mainStream
        stream.send(message: message)
    }
}

extension TransferFlowDetailTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        cellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = cellModels[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
}
