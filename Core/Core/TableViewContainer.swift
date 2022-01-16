//
//  TableViewContainer.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

protocol TableViewContainer: Container
{
    var model: TableViewModel { get set }
    var stream: Stream { get set }
    var style: UITableView.Style { get }
}
