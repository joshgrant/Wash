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

public class TableViewDelegateModel
{
    // MARK: - Variables
    
    var headerViews: [UIView?]?
    var sectionHeaderHeights: [CGFloat]?
    var estimatedSectionHeaderHeights: [CGFloat]?
    var didSelect: TableViewSelectionClosure?
    
    // MARK: - Initialization
    
    init(headerViews: [UIView?]?,
         sectionHeaderHeights: [CGFloat]?,
         estimatedSectionHeaderHeights: [CGFloat]?,
         didSelect: TableViewSelectionClosure?)
    {
        self.headerViews = headerViews
        self.sectionHeaderHeights = sectionHeaderHeights
        self.estimatedSectionHeaderHeights = estimatedSectionHeaderHeights ?? sectionHeaderHeights
        self.didSelect = didSelect
    }
}
