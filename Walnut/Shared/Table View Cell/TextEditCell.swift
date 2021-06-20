//
//  TextEditCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class TextEditCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var text: String?
    var placeholder: String
    
    // MARK: - Initialization
    
    init(text: String?, placeholder: String)
    {
        self.text = text
        self.placeholder = placeholder
    }
    
    static var cellClass: AnyClass { TextEditCell.self }
}

class TextEditCell: TableViewCell<TextEditCellModel>
{
    // TODO: Title began editing
    // TODO: Title ended editing
    // TODO: Title changed text
    
    // MARK: - Variables
    
    var textField: UITextField
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        textField = UITextField()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
        
        let contentStackView = UIStackView(arrangedSubviews: [textField])
        contentStackView.set(height: 44)
        
        contentView.embed(
            contentStackView,
            padding: .init(
                top: 0,
                left: 16,
                bottom: 0,
                right: 5),
            bottomPriority: .defaultLow)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: TextEditCellModel)
    {
        textField.placeholder = model.placeholder
        textField.text = model.text
    }
}
