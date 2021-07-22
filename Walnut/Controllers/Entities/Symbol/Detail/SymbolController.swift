//
//  SymbolController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol SymbolControllerFactory: Factory
{
    func makeController() -> SymbolController
    func makeTableView() -> TableView<SymbolTableViewContainer>
}

class SymbolControllerContainer: Container
{
    // MARK: - Variables
    
    var symbol: Symbol
    var stream: Stream
    
    // MARK: - Initialization
    
    init(symbol: Symbol, stream: Stream)
    {
        self.symbol = symbol
        self.stream = stream
    }
}

extension SymbolControllerContainer: SymbolControllerFactory
{
    func makeController() -> SymbolController
    {
        .init(container: self)
    }
    
    func makeTableView() -> TableView<SymbolTableViewContainer>
    {
        let container = SymbolTableViewContainer(
            symbol: symbol,
            stream: stream,
            style: .grouped)
        return .init(container: container)
    }
}

class SymbolController: ViewController<SymbolControllerContainer>
{
    // MARK: - Variables
    
    var tableView: TableView<SymbolTableViewContainer>
    
    // MARK: - Initialization
    
    required init(container: SymbolControllerContainer)
    {
        self.tableView = container.makeTableView()
        super.init(container: container)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.embed(tableView)
    }
}
