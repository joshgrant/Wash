//
//  CurrentDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

protocol CurrentDetailFactory: Factory
{
    func makeController() -> CurrentDetailController
    func makeTableView() -> TableView<CurrentDetailTableViewContainer>
}

class CurrentDetailContainer: Container
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

extension CurrentDetailContainer: CurrentDetailFactory
{
    func makeController() -> CurrentDetailController
    {
        .init(container: self)
    }
    
    func makeTableView() -> TableView<CurrentDetailTableViewContainer>
    {
        let container = CurrentDetailTableViewContainer(
            stream: stream,
            style: .grouped,
            stock: stock)
        return container.makeTableView()
    }
}

class CurrentDetailController: ViewController<CurrentDetailContainer>
{
    // MARK: - Variables
    
    var tableView: TableView<CurrentDetailTableViewContainer>
    
    // MARK: - Initialization
    
    required init(container: CurrentDetailContainer)
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
