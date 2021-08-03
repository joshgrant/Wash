//
//  StocksHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

protocol StocksHeaderViewModelFactory: Factory
{
    func makeHeaderViewModel() -> StocksHeaderViewModel
    func makeDisclosureTriangleActionClosure() -> ActionClosure
    func makeSearchButtonActionClosure() -> ActionClosure
    func makeAddButtonActionClosure() -> ActionClosure
}

class StocksHeaderViewModelContainer: Container
{
    // MARK: - Variables
    
//    var system: System
    var stream: Stream
    
    // MARK: - Initialization
    
    init(stream: Stream)
    {
//        self.system = system
        self.stream = stream
    }
}

extension StocksHeaderViewModelContainer: StocksHeaderViewModelFactory
{
    func makeHeaderViewModel() -> StocksHeaderViewModel
    {
        .init(container: self)
    }
    
    func makeDisclosureTriangleActionClosure() -> ActionClosure
    {
        ActionClosure { _ in
            print("DISCLOSE")
        }
    }
    
    func makeSearchButtonActionClosure() -> ActionClosure
    {
        // FIXME: No action
        ActionClosure { _ in
//            guard let self = self else { return }
//            let message = SectionHeaderSearchMessage(entityToSearchFrom: self.system, typeToSearch: Stock.self)
//            self.stream.send(message: message)
        }
    }
    
    func makeAddButtonActionClosure() -> ActionClosure
    {
        // FIXME: No action
        ActionClosure { _ in
//            guard let self = self else { return }
//            let message = SectionHeaderAddMessage(entityToAddTo: self.system, entityType: Stock.self)
//            self.stream.send(message: message)
        }
    }
}

class StocksHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init(container: StocksHeaderViewModelContainer)
    {
        self.init(title: "Stocks".localized, icon: .stock)
        
        disclosureTriangleActionClosure = container.makeDisclosureTriangleActionClosure()
        searchButtonActionClosure = container.makeSearchButtonActionClosure()
        addButtonActionClosure = container.makeAddButtonActionClosure()
    }
}
