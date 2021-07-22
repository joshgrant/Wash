//
//  IdealDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

protocol IdealDetailFactory: Factory
{
    func makeController() -> IdealDetailController
    func makeTableView() -> TableView<IdealDetailTableViewContainer>
}

class IdealDetailContainer: Container
{
    // MARK: - Variables
    
    var stock: Stock
    var stream: Stream
    
    lazy var tableView = makeTableView()
    
    // MARK: - Initialization
    
    init(stock: Stock, stream: Stream)
    {
        self.stock = stock
        self.stream = stream
    }
}

extension IdealDetailContainer: IdealDetailFactory
{
    func makeController() -> IdealDetailController
    {
        .init(container: self)
    }
    
    func makeTableView() -> TableView<IdealDetailTableViewContainer>
    {
        let container = IdealDetailTableViewContainer(
            stream: stream,
            style: .grouped,
            stock: stock)
        return .init(container: container)
    }
}

class IdealDetailController: ViewController<IdealDetailContainer>
{
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.embed(container.makeTableView())
    }
}
