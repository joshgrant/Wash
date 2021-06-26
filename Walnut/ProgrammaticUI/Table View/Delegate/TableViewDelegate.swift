//
//  TableViewDelegate.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class TableViewDelegate: NSObject, UITableViewDelegate
{
    // MARK: - Variables
    
    public var model: TableViewDelegateModel
    
    // MARK: - Initialization
    
    public init(model: TableViewDelegateModel)
    {
        self.model = model
    }
}

public extension TableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        model.estimatedSectionHeaderHeights?[section] ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        model.sectionHeaderHeights?[section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let headerViews = model.headerViews else
        {
            return nil
        }

        if headerViews.count > section
        {
            return headerViews[section]
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        nil
    }
}

public extension TableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tableViewSelection = TableViewSelection(
            tableView: tableView,
            indexPath: indexPath)
        if let newAppState = model.didSelect?(tableViewSelection)
        {
            print(newAppState)
        }
        else
        {
            print("Selected row, but no new state")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
