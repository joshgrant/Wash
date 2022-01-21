//
//  StockDetailView.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class StockDetailView: View
{
    var context: Context
    
    init(context: Context)
    {
        self.context = context
        super.init()
    }
    
    override func display()
    {
        print("Stock Detail View")
    }
}
