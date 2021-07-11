//
//  TextCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import UIKit

class TextCellModel: TableViewCellModel
{
    // MARK: - Variables
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var disclosureIndicator: Bool
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        disclosureIndicator: Bool = false)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.disclosureIndicator = disclosureIndicator
    }
    
    static var cellClass: AnyClass { TextCell.self }
}

class TextCell: TableViewCell<TextCellModel>
{
    // MARK: - Configuration
    
    override func configure(with model: TextCellModel)
    {
        textLabel?.text = model.title
        
        if model.disclosureIndicator
        {
            accessoryType = .disclosureIndicator
        }
    }
}
