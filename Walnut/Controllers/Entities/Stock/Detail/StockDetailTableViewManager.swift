//
//  StockDetailTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class StockDetailTableViewManager: NSObject
{
    // MARK: - Variables
    
    var stock: Stock
    var headerViews: [TableHeaderView]
    var cellModels: [[TableViewCellModel]]
    
    var needsReload: Bool = false
    var tableView: UITableView
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        self.cellModels = Self.makeCellModels(stock: stock)
        
        self.tableView = UITableView(frame: .zero, style: .grouped)
        
        self.headerViews = Self.makeHeaderViews()
        
        super.init()
        
        Self.cellModelTypes().forEach
        {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Functions
    
    func reload()
    {
        self.cellModels = Self.makeCellModels(stock: stock)
        tableView.reloadData()
        needsReload = false
    }
    
    // MARK: - Factory
    
    static func cellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            TextEditCellModel.self,
            DetailCellModel.self,
            SubtitleDetailCellModel.self,
            InfoCellModel.self
        ]
    }
    
    static func makeCellModels(stock: Stock) -> [[TableViewCellModel]]
    {
        [
            makeInfoSection(stock: stock),
            [],
            makeInflowCellModels(stock: stock),
            makeOutflowCellModels(stock: stock),
            makeEventsCellModels(stock: stock),
            []
        ]
    }
    
    static func makeInfoSection(stock: Stock) -> [TableViewCellModel]
    {
        [
            TextEditCellModel(
                text: stock.title,
                placeholder: "Title".localized,
                entity: stock),
            DetailCellModel(
                title: "Type".localized,
                detail: stockTypeDetail(stock: stock),
                disclosure: true),
            DetailCellModel(
                title: "Dimension".localized,
                detail: "Currency",
                disclosure: true),
            DetailCellModel(
                title: "Current".localized,
                detail: "Relaxed",
                disclosure: true), // TODO Subtitle
            InfoCellModel(
                title: "Net".localized,
                detail: "3980/month")
        ]
    }
    
    static func stockTypeDetail(stock: Stock) -> String
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
    
    static func makeInflowCellModels(stock: Stock) -> [TableViewCellModel]
    {
        let inflows = stock.unwrappedInflows
        return inflows.map { flow in
            SubtitleDetailCellModel(
                title: flow.title,
                subtitle: "AMOUNT???",
                detail: "Some -> Some",
                tall: true)
        }
    }
    
    static func makeOutflowCellModels(stock: Stock) -> [TableViewCellModel]
    {
        let outflows = stock.unwrappedOutflows
        return outflows.map {
            SubtitleDetailCellModel(
                title: $0.title,
                subtitle: "from -> to",
                detail: "AMOUNT???",
                tall: true)
        }
    }
    
    static func makeEventsCellModels(stock: Stock) -> [TableViewCellModel]
    {
        let events = stock.unwrappedEvents
        return events.map {
            let flowCount = $0.flows?.count ?? 0
            let flowSubtitle = "\(flowCount) flow\(flowCount == 1 ? "" : "s")"
            return DetailCellModel(
                title: $0.title,
                detail: flowSubtitle,
                disclosure: true)
        }
    }
    
    static func makeNotesCellModels(stock: Stock) -> [TableViewCellModel]
    {
        let notes: [Note] = stock.unwrapped(\Stock.notes)
        return notes.map {
            // TODO: Subtitle
            return DetailCellModel(
                title: $0.title,
                detail: $0.firstLine ?? "",
                disclosure: true)
        }
    }
    
    static func makeHeaderViews() -> [TableHeaderView]
    {
        let models = makeHeaderViewModels()
        return models.map { TableHeaderView(model: $0) }
    }
    
    static func makeHeaderViewModels() -> [TableHeaderViewModel]
    {
        return [
            InfoHeaderViewModel(),
            StatesHeaderViewModel(), // Only if the stock has states...
            InflowsHeaderViewModel(),
            OutflowsHeaderViewModel(),
            EventsHeaderViewModel(),
            NotesHeaderViewModel()
        ]
    }
}

extension StockDetailTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        headerViews[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = TableViewSelectionMessage(
            tableView: tableView,
            indexPath: indexPath,
            token: .stockDetail)
        StockDetailController.stream.send(message: message)
    }
}

extension StockDetailTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = cellModels[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
}
