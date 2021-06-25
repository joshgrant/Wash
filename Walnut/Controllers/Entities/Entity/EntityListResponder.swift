//
//  EntityListPresenter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/24/21.
//

import Foundation
import UIKit

protocol Responder: AnyObject {}

// The job of a responder is to take user-actions as
// initiated from the UI layer and decide what to do with them. These are "events" that are either generated from the UI or from notifications. Essentially a dispatcher.
class EntityListResponder: Responder
{
    func userTouchedUpInsideAddButton(sender: UIButton)
    {
        
    }
    
    func userSelectedCell(
        in tableView: UITableView,
        at indexPath: IndexPath)
    {
        
    }
}
