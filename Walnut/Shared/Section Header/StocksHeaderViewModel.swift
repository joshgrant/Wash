//
//  StocksHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class StocksHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init(system: System)
    {
        self.init(
            title: "Stocks".localized,
            icon: .stock)
        
        disclosureTriangleActionClosure = ActionClosure { sender in
            print("DISCLOSE")
        }
        
        searchButtonActionClosure = ActionClosure { sender in
            print("SEARCH")
        }
        
        addButtonActionClosure = ActionClosure { sender in
            let message = SectionHeaderAddMessage(
                entityToAddTo: system,
                entityType: Stock.self)
            AppDelegate.shared.mainStream.send(message: message)
        }
    }
}
