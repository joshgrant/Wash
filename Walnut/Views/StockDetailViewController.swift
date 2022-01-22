//
//  StockDetailViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class StockDetailView: View
{
    var stock: Stock
    
    init(stock: Stock)
    {
        self.stock = stock
    }
    
    override func display()
    {
        print("1. Info")
        print("2. \(Icon.state.text) States")
        print("3. \(Icon.leftArrow.text) Inflows")
        print("4. \(Icon.rightArrow.text) Outflows")
        print("5. \(Icon.note.text) Notes")
    }
}

class StockDetailViewController: ViewController
{
    var stock: Stock
    
    init(stock: Stock)
    {
        self.stock = stock
        super.init(title: stock.title,
                   view: StockDetailView(stock: stock))
    }
}
