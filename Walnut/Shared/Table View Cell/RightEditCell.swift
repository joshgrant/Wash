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
    var keyboardType: UIKeyboardType?
    var newStockModel: NewStockModel?
    var stream: Stream
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        detail: String?,
        detailPostfix: String?,
        keyboardType: UIKeyboardType?,
        newStockModel: NewStockModel?,
        stream: Stream)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.detail = detail
        self.detailPostfix = detailPostfix
        self.keyboardType = keyboardType
        self.newStockModel = newStockModel
        self.stream = stream
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
        rightField.delegate = self
        
        if let type = model.keyboardType
        {
            rightField.keyboardType = type
        }
        else
        {
            let keyboard = NumericKeyboard()
            keyboard.translatesAutoresizingMaskIntoConstraints = false
            keyboard.delegate = self
            keyboard.target = rightField
            rightField.inputView = keyboard
        }
        
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
        
        model?.stream.send(message: message)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let model = model else { fatalError() }
        guard let text = textField.text else { fatalError() }
        
        let message = RightEditCellMessage(
            selectionIdentifier: model.selectionIdentifier,
            content: text,
            editType: .dismiss)
        
        model.stream.send(message: message)
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        guard let model = model else { fatalError() }
//        guard let text = textField.text else { return true }
//        guard let range = Range<String.Index>(range, in: text) else { return true }
//        let newText = text.replacingCharacters(in: range, with: string)
////        guard var newValue = Double(newText) else { return true }
//
//        defer
//        {
//            let message = RightEditCellMessage(
//                selectionIdentifier: model.selectionIdentifier,
//                content: newText,
//                editType: .edit)
//
//            // TODO: Maybe streams should be tagged - like a "text stream" or something like that
//            // so we avoid sending huge updates to everybody
//            AppDelegate.shared.mainStream.send(message: message)
//        }
//
//        return true
//    }
}

extension RightEditCell: NumericKeyboardDelegate
{
    func toggleSign(keyboard: NumericKeyboard)
    {
        if keyboard.negative
        {
            let characterSet = CharacterSet(charactersIn: "-")
            rightField.text = rightField.text?.trimmingCharacters(in: characterSet)
        }
        else
        {
            rightField.text = "-" + (rightField.text ?? "")
        }
        update()
    }
    
    func setInfinity(keyboard: NumericKeyboard)
    {
        if keyboard.negative
        {
            rightField.text = "-∞"
        }
        else
        {
            rightField.text = "∞"
        }
        update()
    }
    
    func number(keyboard: NumericKeyboard)
    {
        update()
    }
    
    func enter(keyboard: NumericKeyboard)
    {
        rightField.endEditing(false)
    }
    
    func update()
    {
        guard let model = model else { fatalError() }
        guard let text = rightField.text else { fatalError() }
        
        let message = RightEditCellMessage(
            selectionIdentifier: model.selectionIdentifier,
            content: text,
            editType: .edit)
        
        // TODO: Maybe streams should be tagged - like a "text stream" or something like that
        // so we avoid sending huge updates to everybody
        model.stream.send(message: message)
    }
}
