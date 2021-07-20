//
//  TextEditCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class TextEditCellModel: NSObject, TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    
    var text: String?
    var placeholder: String
    var entity: Entity?
    var keyboardType: UIKeyboardType
    var stream: Stream
    
    var notifyOnDismissal: Bool = true
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        text: String?,
        placeholder: String,
        entity: Entity?,
        keyboardType: UIKeyboardType = .default,
        stream: Stream)
    {
        self.selectionIdentifier = selectionIdentifier
        self.text = text
        self.placeholder = placeholder
        self.entity = entity
        self.keyboardType = keyboardType
        self.stream = stream
    }
    
    static var cellClass: AnyClass { TextEditCell.self }
}

class TextEditCell: TableViewCell<TextEditCellModel>
{
    // MARK: - Variables
    
    weak var model: TextEditCellModel?
    
    var selectionIdentifier: SelectionIdentifier?
    var notifyOnDismissal: Bool = true
    var textField: UITextField
    
    var isEmpty: Bool
    {
        textField.text?.isEmpty ?? true
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        textField = UITextField()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
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
        self.model = model
        
        self.notifyOnDismissal = model.notifyOnDismissal
        self.selectionIdentifier = model.selectionIdentifier
        
        textField.placeholder = model.placeholder
        textField.text = model.text
        textField.delegate = self
        textField.keyboardType = model.keyboardType
    }
}

extension TextEditCell: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard notifyOnDismissal else { return }
        
        guard let identifier = selectionIdentifier else { fatalError() }
        
        let title = textField.text ?? ""
        let message = TextEditCellMessage(
            selectionIdentifier: identifier,
            title: title)
        
        model?.stream.send(message: message)
    }
}
