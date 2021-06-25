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
    
    // MARK: - Initialization
    
    required init(model: EntityListViewModel)
    {
        tableView = TableView(model: model.tableViewModel)
        barButtonItem = Self.makeAddBarButtonItem(model: model)
        super.init(model: model)
        embed(tableView)
    }
    
    // MARK: - Factory
    
    static func makeAddBarButtonItem(model: EntityListViewModel) -> UIBarButtonItem
    {
        // TODO: We need some object who's job it is to
        // handle user interactons (interactor, right?)
        UIBarButtonItem(
            image: model.addButtonImage,
            style: model.addButtonStyle,
            target: nil,
            action: nil)
    }
}
