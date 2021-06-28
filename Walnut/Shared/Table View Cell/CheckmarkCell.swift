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
    
    var title: String
    var checked: Bool
    
    // MARK: - Initialization
    
    init(title: String, checked: Bool)
    {
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
