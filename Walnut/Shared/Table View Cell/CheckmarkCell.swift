//
//  CheckmarkCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class CheckmarkCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var checked: Bool
    var enabled: Bool
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        checked: Bool,
        enabled: Bool = true)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.checked = checked
        self.enabled = enabled
    }
    
    static var cellClass: AnyClass { CheckmarkCell.self }
}

class CheckmarkCell: TableViewCell<CheckmarkCellModel>
{
    override func configure(with model: CheckmarkCellModel)
    {
        textLabel?.text = model.title
        accessoryType = (model.checked && model.enabled)
            ? .checkmark
            : .none
        
        isUserInteractionEnabled = model.enabled
        textLabel?.textColor = model.enabled ? .label : .secondaryLabel
    }
}
