//
//  LibraryCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import UIKit

class LibraryCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var icon: Icon
    var title: String
    var count: Int
    
    // MARK: - Initialization
    
    init(icon: Icon, title: String, count: Int)
    {
        self.icon = icon
        self.title = title
        self.count = count
    }
    
    convenience init(entityType: EntityType, context: Context)
    {
        self.init(
            icon: entityType.icon,
            title: entityType.title,
            count: entityType.count(in: context))
    }
    
    static var cellClass: AnyClass { LibraryCell.self }
}

class LibraryCell: TableViewCell<LibraryCellModel>
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    override func configure(with model: LibraryCellModel)
    {
        self.accessoryType = .disclosureIndicator
        
        self.imageView?.image = model.icon.getImage()
        self.imageView?.tintColor = .systemGray
        
        self.textLabel?.text = model.title
        
        self.detailTextLabel?.text = "\(model.count)"
    }
}
