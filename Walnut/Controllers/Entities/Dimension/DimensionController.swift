//
//  DimensionController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class DimensionController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var dimension: Dimension
    var tableView: DimensionTableView
    
    // MARK: - Initialization
    
    init(dimension: Dimension)
    {
        self.dimension = dimension
        self.tableView = DimensionTableView(dimension: dimension)
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = dimension.title
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
}

extension DimensionController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TextEditCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        guard message.entity == dimension else { return }
        title = message.title
        dimension.title = message.title
        dimension.managedObjectContext?.quickSave()
    }
}
