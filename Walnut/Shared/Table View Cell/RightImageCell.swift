//
//  RightImageCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class RightImageCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var detail: Icon
    var disclosure: Bool
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        detail: Icon,
        disclosure: Bool)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.detail = detail
        self.disclosure = disclosure
    }
    
    static var cellClass: AnyClass { RightImageCell.self }
}

class RightImageCell: TableViewCell<RightImageCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var rightImageView: UIImageView
    
    var mainStackView: UIStackView
    
    // MARK: - Initialization
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        self.titleLabel = UILabel()
        self.rightImageView = UIImageView()
        self.rightImageView.tintColor = .secondaryLabel
        
        mainStackView = UIStackView(arrangedSubviews: [
                                        titleLabel,
                                        SpacerView(),
                                        rightImageView])
        mainStackView.set(height: 44)
        mainStackView.alignment = .center
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding = UIEdgeInsets(
            top: 0, left: 16,
            bottom: 0, right: 16)
        
        contentView.embed(
            mainStackView,
            padding: padding,
            bottomPriority: .defaultLow,
            rightPriority: .defaultLow)
    }
    
    override func configure(with model: RightImageCellModel)
    {
        self.titleLabel.text = model.title
        self.rightImageView.image = model.detail.getImage()
        
        accessoryType = model.disclosure
            ? .disclosureIndicator
            : .none
    }
}
