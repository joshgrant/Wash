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

    var tableViewData: TableViewData
    var tableView: UITableView
    
    var flow: TransferFlow
    
    weak var _stream: Stream?
    var stream: Stream { return _stream ?? AppDelegate.shared.mainStream }
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, stream: Stream)
    {
        self.flow = flow
        self._stream = stream
        
        self.tableView = UITableView(
            frame: .zero,
            style: .grouped)
        
        self.tableViewData = TableViewData.transferFlowDetail(flow: flow, stream: stream)
        
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
}

extension TransferFlowDetailTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let model = tableViewData.headers[section] else
        {
            return nil
        }
        
        return TableHeaderView(model: model)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        tableViewData.footers[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = TableViewSelectionMessage(
            tableView: tableView,
            indexPath: indexPath,
            token: .transferFlowDetail)

        stream.send(message: message)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TransferFlowDetailTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        tableViewData.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableViewData.models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = tableViewData
            .models[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
}
