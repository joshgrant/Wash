//
//  StockDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class StockDetailController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var stock: Stock
    var responder: StockDetailResponder
    var tableViewManager: StockDetailTableViewManager
    
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(stock: Stock, navigationController: NavigationController?)
    {
        let responder = StockDetailResponder(stock: stock)
        
        self.stock = stock
        self.responder = responder
        self.tableViewManager = StockDetailTableViewManager(stock: stock)
        
        self.pinBarButtonItem = Self.makePinNavigationItem(stock: stock, responder: responder)
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = stock.title
        
        view.embed(tableViewManager.tableView)
        
        navigationItem.setRightBarButtonItems([pinBarButtonItem], animated: false)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    static func makePinNavigationItem(stock: Stock, responder: StockDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: stock.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.userTouchedUpInsidePin(sender:)))
    }
}

extension StockDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let x as TextEditCellMessage:
            handleTextEditCellMessage(x)
        case let x as EntityPinnedMessage:
            handleStockPinnedMessage(x)
        default:
            break
        }
    }
    
    func handleTextEditCellMessage(_ message: TextEditCellMessage)
    {
        guard message.entity == stock else { return }
        
        title = message.title
        stock.title = message.title
        stock.managedObjectContext?.quickSave()
    }
    
    // TODO: The same as the system detail
    func handleStockPinnedMessage(_ message: EntityPinnedMessage)
    {
        guard message.entity == stock else { return }
        
        let pinned = message.isPinned
        
        pinBarButtonItem.image = pinned
            ? Icon.pinFill.getImage()
            : Icon.pin.getImage()
        
        stock.isPinned = pinned
        stock.managedObjectContext?.quickSave()
    }
}
