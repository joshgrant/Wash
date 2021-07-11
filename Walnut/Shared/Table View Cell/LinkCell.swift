//
//  LinkCell.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import UIKit

class LinkCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var subtitle: String
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        subtitle: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.subtitle = subtitle
    }
    
    static var cellClass: AnyClass { LinkCell.self }
}

class LinkCell: TableViewCell<LinkCellModel>
{
    // MARK: - Initialization
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: LinkCellModel)
    {
        textLabel?.text = model.title
        detailTextLabel?.text = model.subtitle
    }
}
