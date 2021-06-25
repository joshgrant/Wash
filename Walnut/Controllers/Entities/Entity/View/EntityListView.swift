//
//  EntityListView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class EntityListView: View<EntityListViewModel>
{
    // MARK: - Variables
    
    var tableView: TableView<EntityListTableViewModel>
    var barButtonItem: UIBarButtonItem
    weak var responder: EntityListResponder?
    
    // MARK: - Initialization
    
    required init(model: EntityListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        barButtonItem = Self.makeAddBarButtonItem(
            model: model,
            responder: responder)
        
        super.init(model: model)
        
        embed(tableView)
    }
    
    convenience init(
        model: EntityListViewModel,
        responder: EntityListResponder)
    {
        self.init(model: model)
        self.responder = responder
    }
    
    // MARK: - Factory
    
    static func makeAddBarButtonItem(
        model: EntityListViewModel,
        responder: EntityListResponder?) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: model.addButtonImage,
            style: model.addButtonStyle,
            target: responder,
            action: #selector(responder?.userTouchedUpInsideAddButton(sender:)))
    }
}
