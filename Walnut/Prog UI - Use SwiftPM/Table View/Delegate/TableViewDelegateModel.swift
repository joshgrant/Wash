//
//  TableViewDelegateModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

typealias TableViewSelectionClosure = ((TableViewSelection) -> Void)

public struct TableViewSelection
{
    var tableView: UITableView
    var indexPath: IndexPath
}

public struct TableViewDelegateModel
{
    var headerViews: [UIView?]?
    var sectionHeaderHeights: [CGFloat]?
    var estimatedSectionHeaderHeights: [CGFloat]?
    var didSelect: TableViewSelectionClosure?
}
