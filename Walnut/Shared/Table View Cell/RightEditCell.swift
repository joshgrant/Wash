//
//  RightEditCell.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class RightEditCellModel: NSObject, TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var detail: String?
    var detailPostfix: String?
    var keyboardType: UIKeyboardType
    
    // MARK: - Initialization
    
    init(selectionIdentifier: SelectionIdentifier, title: String, detail: String?, detailPostfix: String?, keyboardType: UIKeyboardType)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.detail = detail
        self.detailPostfix = detailPostfix
        self.keyboardType = keyboardType
    }
    
    static var cellClass: AnyClass { RightEditCell.self }
}

class RightEditCell: TableViewCell<RightEditCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var rightField: UITextField
    var postfixLabel: UILabel
    var selectionIdentifier: SelectionIdentifier?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        titleLabel = UILabel()
        rightField = UITextField()
        postfixLabel = UILabel()
        
        rightField.textColor = .secondaryLabel
        postfixLabel.textColor = .secondaryLabel
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        postfixLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        rightField.textAlignment = .right
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, rightField, postfixLabel])
        let contentInsets = UIEdgeInsets(
            top: 0, left: 16,
            bottom: 0, right: 16)
        
        contentView.embed(
            stackView,
            padding: contentInsets)
    }
    
    // MARK: - Functions
    
    override func configure(with model: RightEditCellModel)
    {
        self.selectionIdentifier = model.selectionIdentifier
        
        titleLabel.text = model.title
        rightField.text = model.detail
        rightField.keyboardType = model.keyboardType
        rightField.delegate = self
        
        if let postfix = model.detailPostfix
        {
            postfixLabel.text = postfix
        }
        else
        {
            postfixLabel.removeFromSuperview()
        }
    }
}

extension RightEditCell: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        print("RESIGNED")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let identifier = selectionIdentifier else { fatalError() }
        print("ENDED")
        
        let message = RightEditCellMessage(
            selectionIdentifier: identifier,
            content: textField.text ?? "")
        
        AppDelegate.shared.mainStream.send(message: message)
    }
}
