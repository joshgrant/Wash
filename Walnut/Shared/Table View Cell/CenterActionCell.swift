//
//  CenterActionCell.swift
//  Walnut
//
//  Created by Joshua Grant on 7/15/21.
//

import Foundation
import UIKit

class CenterActionCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    
    // MARK: - Initialization
    
    init(selectionIdentifier: SelectionIdentifier, title: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
    }
    
    static var cellClass: AnyClass { CenterActionCell.self }
}

class CenterActionCell: TableViewCell<CenterActionCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemBlue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.embed(titleLabel)
    }
    
    override func configure(with model: CenterActionCellModel)
    {
        titleLabel.text = model.title
    }
}
