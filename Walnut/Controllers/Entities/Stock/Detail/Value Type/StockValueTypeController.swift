//
//  StockValueTypeController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

protocol StockValueTypeFactory: Factory
{
    func makeTableView() -> StockTypeTableView
    func makeModel() -> TableViewModel
}

class StockValueTypeContainer: DependencyContainer
{
    // MARK: - Variables
    
    var stock: Stock
    var stream: Stream
    
    lazy var tableView: StockTypeTableView = makeTableView()
    
    // MARK: - Initialization
    
    init(stock: Stock, stream: Stream)
    {
        self.stock = stock
        self.stream = stream
    }
}

extension StockValueTypeContainer: StockValueTypeFactory
{
    func makeTableView() -> StockTypeTableView
    {
        let model = makeModel()
        let container = StockTypeTableViewContainer(
            model: model,
            stream: stream,
            style: .grouped,
            stock: stock)
        return StockTypeTableView(container: container)
    }
    
    func makeModel() -> TableViewModel
    {
        
    }
}

class StockValueTypeController: ViewController<StockValueTypeContainer>
{
    // MARK: - Variables
    
//    var stock: Stock
//    var tableView: StockTypeTableView
    
    // MARK: - Initialization
    
    required init(container: StockValueTypeContainer)
    {
        super.init(container: container)
        view.embed(container.tableView)
    }
    
//    init(container: StockValueTypeContainer)
//    {
//        self.stock = stock
//        let container = StockTypeTableViewContainer(model: <#T##TableViewModel#>, stream: <#T##Stream#>, style: <#T##UITableView.Style#>, stock: stock)
//        tableView = StockTypeTableView(container: <#T##StockTypeTableViewContainer#>)
//
//        super.init(nibName: nil, bundle: nil)
//
//        view.embed(tableView)
//    }
    
//    required init?(coder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
}
