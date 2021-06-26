//
//  TableViewDelegateModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public typealias TableViewSelectionClosure = ((TableViewSelection) -> Void)

public struct TableViewSelection
{
    public var tableView: UITableView
    public var indexPath: IndexPath
}

open class TableViewDelegateModel
{
    // MARK: - Variables
    
    public var headerViews: [UIView?]?
    public var sectionHeaderHeights: [CGFloat]?
    public var estimatedSectionHeaderHeights: [CGFloat]?
    public var didSelect: TableViewSelectionClosure?
    
    // MARK: - Initialization
    
    public init(headerViews: [UIView?]?,
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
