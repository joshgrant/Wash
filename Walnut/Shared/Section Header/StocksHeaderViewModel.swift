//
//  StocksHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation

class StocksHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init(system: System, navigationController: UINavigationController?)
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
            guard let context = system.managedObjectContext else
            {
                assertionFailure("Failed to get the managed object context of the system")
                return
            }
            
            let stock = Stock(context: context)
            system.addToStocks(stock)
            let detailController = stock.detailController(navigationController: navigationController)
            navigationController?.present(detailController, animated: true, completion: nil)
        }
    }
}
