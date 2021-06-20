//
//  StocksHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class StocksHeaderViewModel: TableHeaderViewModel
{
    convenience init(system: System, navigationController: NavigationController)
    {
        self.init(
            title: "Stocks".localized,
            icon: Icon.stock)
        
        disclosureTriangleActionClosure = ActionClosure { sender in
            print("DISCLOSE")
        }
        
        searchButtonActionClosure = ActionClosure { sender in
            print("SEARCH")
        }
        
        addButtonActionClosure = ActionClosure { sender in
            guard let context = system.managedObjectContext else
            {
                assertionFailure("Failed to get the managed object context of the system")
                return
            }
            
            let newStock = Stock(context: context)
            system.addToStocks(newStock)
            
            // TODO: Present the new stock page
            
            // We want to open up the stock detail page (modally?)
            // with the stock that we just added
        }
    }
}
