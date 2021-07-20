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
    func makeController() -> StockValueTypeController
    func makeTableView() -> StockTypeTableView
}

class StockValueTypeContainer: DependencyContainer
{
    // MARK: - Variables
    
    var stock: Stock
    var stream: Stream
    
    // MARK: - Initialization
    
    init(stock: Stock, stream: Stream)
    {
        self.stock = stock
        self.stream = stream
    }
}

extension StockValueTypeContainer: StockValueTypeFactory
{
    func makeController() -> StockValueTypeController
    {
        .init(container: self)
    }
    
    func makeTableView() -> StockTypeTableView
    {
        let container = StockTypeTableViewContainer(
            stream: stream,
            style: .grouped,
            stock: stock)
        return StockTypeTableView(container: container)
    }
}

class StockValueTypeController: ViewController<StockValueTypeContainer>
{
    // MARK: - Variables
    
    var tableView: StockTypeTableView
    
    // MARK: - Initialization
    
    required init(container: StockValueTypeContainer)
    {
        tableView = container.makeTableView()
        super.init(container: container)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.embed(tableView)
    }
}
