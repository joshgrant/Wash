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
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        checked: Bool)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.checked = checked
    }
    
    static var cellClass: AnyClass { CheckmarkCell.self }
}

class CheckmarkCell: TableViewCell<CheckmarkCellModel>
{
    override func configure(with model: CheckmarkCellModel)
    {
        textLabel?.text = model.title
        accessoryType = model.checked
            ? .checkmark
            : .none
    }
}
