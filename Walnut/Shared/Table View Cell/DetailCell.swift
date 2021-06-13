//
//  DetailCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class DetailCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var title: String
    var detail: String
    
    // MARK: - Initialization
    
    init(title: String, detail: String)
    {
        self.title = title
        self.detail = detail
    }
    
    static var cellClass: AnyClass { DetailCell.self }
}

class DetailCell: TableViewCell<DetailCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var detailLabel: UILabel
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        titleLabel = UILabel()
        detailLabel = UILabel()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
        
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        contentStackView.set(height: 44)
        
        let stackViewPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        contentView.embed(
            contentStackView,
            padding: stackViewPadding,
            bottomPriority: .defaultLow)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: DetailCellModel)
    {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
}
