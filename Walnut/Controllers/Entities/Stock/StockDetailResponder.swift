//
//  StockDetailResponder.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class StockDetailResponder: Responder
{
    // MARK: - Variables
    
    var stock: Stock
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
    }
    
    // MARK: - Functions
    
    @objc func userTouchedUpInsidePin(sender: UIBarButtonItem)
    {
        stock.isPinned.toggle()
        let message = EntityPinnedMessage(
            isPinned: stock.isPinned,
            entity: stock)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
