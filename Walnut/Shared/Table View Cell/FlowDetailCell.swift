//
//  FlowDetailCell.swift
//  Walnut
//
//  Created by Joshua Grant on 7/12/21.
//

import Foundation
import UIKit

class FlowDetailCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var from: String
    var to: String
    var detail: String
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        from: String,
        to: String,
        detail: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.from = from
        self.to = to
        self.detail = detail
    }
    
    static var cellClass: AnyClass { FlowDetailCell.self }
}

class FlowDetailCell: TableViewCell<FlowDetailCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var fromLabel: UILabel
    var iconImageView: UIImageView
    var toLabel: UILabel
    var detailLabel: UILabel
    
    var fromToStackView: UIStackView
    var leftStackView: UIStackView
    var mainStackView: UIStackView
    
    // MARK: - Initialization
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        titleLabel = UILabel()
        fromLabel = UILabel()
        iconImageView = UIImageView(image: Icon.rightArrow.image)
        toLabel = UILabel()
        detailLabel = UILabel()
        
        fromLabel.textColor = .secondaryLabel
        iconImageView.tintColor = .secondaryLabel
        toLabel.textColor = .secondaryLabel
        detailLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        fromToStackView = UIStackView(arrangedSubviews: [fromLabel, iconImageView, toLabel])
        fromToStackView.setCustomSpacing(6, after: fromLabel)
        fromToStackView.setCustomSpacing(6, after: iconImageView)
        
        leftStackView = UIStackView(arrangedSubviews: [
                                        SpacerView(height: 9),
                                        titleLabel,
                                        fromToStackView,
                                        SpacerView(height: 9)
        ])
        leftStackView.distribution = .equalSpacing
        leftStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [leftStackView, SpacerView(), detailLabel])
        
        let mainStackViewPadding = UIEdgeInsets(
            top: 0, left: 16,
            bottom: 0, right: 16)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.embed(
            mainStackView,
            padding: mainStackViewPadding)
    }
    
    override func configure(with model: FlowDetailCellModel)
    {
        titleLabel.text = model.title
        fromLabel.text = model.from
        toLabel.text = model.to
        detailLabel.text = model.detail
        
        mainStackView.set(height: 60)
    }
}
