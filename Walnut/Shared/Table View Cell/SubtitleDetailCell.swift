//
//  SubtitleDetailCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/27/21.
//

import Foundation
import UIKit

class SubtitleDetailCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var subtitle: String
    var detail: String?
    
    // Whether or not this is a tall or short subtitle cell
    var tall: Bool
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        subtitle: String,
        detail: String?,
        tall: Bool)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.tall = tall
    }
    
    static var cellClass: AnyClass { SubtitleDetailCell.self }
}

class SubtitleDetailCell: TableViewCell<SubtitleDetailCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var detailLabel: UILabel
    
    var leftStackView: UIStackView
    var mainStackView: UIStackView
    
    // MARK: - Initialization
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        self.titleLabel = UILabel()
        self.subtitleLabel = UILabel()
        self.detailLabel = UILabel()
        
        leftStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [leftStackView, detailLabel])
        mainStackView.axis = .horizontal
        
        let mainStackViewPaddding = UIEdgeInsets(
            top: 0, left: 16,
            bottom: 0, right: 16)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.embed(
            mainStackView,
            padding: mainStackViewPaddding,
            bottomPriority: .defaultLow)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: SubtitleDetailCellModel)
    {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        detailLabel.text = model.detail
        
        mainStackView.set(height: model.tall ? 60 : 44)
    }
}
