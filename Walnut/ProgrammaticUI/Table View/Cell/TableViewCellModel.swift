//
//  TableViewCellModel.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public protocol TableViewCellModel
{
    static var cellClass: AnyClass { get }
    static var cellReuseIdentifier: String { get }
}

public extension TableViewCellModel
{
    static var cellReuseIdentifier: String
    {
        String(describing: cellClass)
    }
    
    func makeCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = type(of: self).cellReuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? TableViewCell<Self>
        {
            cell.configure(with: self)
        }
        
        return cell
    }
}
