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
    var newStockModel: NewStockModel?
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        detail: String?,
        detailPostfix: String?,
        keyboardType: UIKeyboardType,
        newStockModel: NewStockModel?)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.detail = detail
        self.detailPostfix = detailPostfix
        self.keyboardType = keyboardType
        self.newStockModel = newStockModel
    }
    
    static var cellClass: AnyClass { RightEditCell.self }
}

class RightEditCell: TableViewCell<RightEditCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var rightField: UITextField
    var postfixLabel: UILabel
    
    weak var model: RightEditCellModel?
    
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
        
        rightField.inputView = NumericKeyboard()
        
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
        self.model = model
        
        titleLabel.text = model.title
        rightField.text = model.detail
//        rightField.keyboardType = model.keyboardType
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
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        guard let identifier = model?.selectionIdentifier else { return }
        
        let message = RightEditCellMessage(
            selectionIdentifier: identifier,
            content: textField.text ?? "",
            editType: .beginEdit)
        
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let model = model else { fatalError() }
        guard let text = textField.text else { return }
        guard var newValue = Double(text) else { return }
        
        switch model.selectionIdentifier
        {
        case .minimum: // Shouldn't be greater than max
            if let max = model.newStockModel?.maximum
            {
                if newValue >= max
                {
                    newValue = max
                }
            }
            
            model.newStockModel!.minimum = newValue
            textField.text = String(format: "%i", Int(newValue))
        case .maximum: // Shouldn't be less than min
            if let min = model.newStockModel?.minimum
            {
                if newValue <= min
                {
                    newValue = min
                }
            }
            
            model.newStockModel!.maximum = newValue
            textField.text = String(format: "%i", Int(newValue))
        default:
            break
        }
        
        let message = RightEditCellMessage(
            selectionIdentifier: model.selectionIdentifier,
            content: textField.text ?? "",
            editType: .dismiss)
        
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let model = model else { fatalError() }
        guard let text = textField.text else { return true }
        guard let range = Range<String.Index>(range, in: text) else { return true }
        let newText = text.replacingCharacters(in: range, with: string)
//        guard var newValue = Double(newText) else { return true }
        
        defer
        {
            let message = RightEditCellMessage(
                selectionIdentifier: model.selectionIdentifier,
                content: newText,
                editType: .edit)
            
            // TODO: Maybe streams should be tagged - like a "text stream" or something like that
            // so we avoid sending huge updates to everybody
            AppDelegate.shared.mainStream.send(message: message)
        }
        
        return true
    }
}
