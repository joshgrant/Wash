//
//  SliderRangeCell.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class SliderRangeCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var value: Float
    var min: Float
    var max: Float
    var postfix: String?
    var keyboardType: UIKeyboardType

    // MARK: - Initialization

    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        value: Float,
        min: Float,
        max: Float,
        postfix: String?,
        keyboardType: UIKeyboardType)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.value = value
        self.min = min
        self.max = max
        self.postfix = postfix
        self.keyboardType = keyboardType
    }
    
    static var cellClass: AnyClass { SliderRangeCell.self }
}

class SliderRangeCell: TableViewCell<SliderRangeCellModel>
{
    // MARK: - Variables
    
    var titleLabel: UILabel
    var rightField: UITextField
    var slider: UISlider
    var postfixLabel: UILabel
    
    weak var model: SliderRangeCellModel?
     
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        titleLabel = UILabel()
        rightField = UITextField()
        slider = UISlider()
        postfixLabel = UILabel()
        
        rightField.textColor = .secondaryLabel
        postfixLabel.textColor = .secondaryLabel
        
        rightField.textAlignment = .right
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        postfixLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, rightField, postfixLabel])
        
        let mainStackView = UIStackView(arrangedSubviews: [
                                            SpacerView(height: 9),
                                            labelStackView,
                                            SpacerView(height: 8),
                                            slider,
                                            SpacerView(height: 9)])
        mainStackView.axis = .vertical
        mainStackView.set(height: 68)
        
        let contentInsets = UIEdgeInsets(
            top: 0, left: 16,
            bottom: 0, right: 16)
        
        contentView.embed(
            mainStackView,
            padding: contentInsets)
    }
    
    override func configure(with model: SliderRangeCellModel)
    {
        self.model = model
        
        slider.minimumValue = model.min
        slider.maximumValue = model.max
        slider.minimumValueImage = Icon.min.getImage()
        slider.maximumValueImage = Icon.max.getImage()
        slider.value = model.value
        slider.isContinuous = true
        
        titleLabel.text = model.title
        rightField.text = String(format: "%i", Int(model.value))
        
        rightField.keyboardType = model.keyboardType
        
        rightField.delegate = self
        
        slider.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)
        
        if let postfix = model.postfix
        {
            postfixLabel.text = postfix
        }
        else
        {
            postfixLabel.removeFromSuperview()
        }
    }
    
    @objc func sliderDidChangeValue(_ sender: UISlider)
    {
        rightField.text = String(format: "%i", Int(sender.value))
    }
}

extension SliderRangeCell: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let newString = textField.text else { return }
        guard let newValue = Float(newString) else { return }
        
        guard let min = model?.min, let max = model?.max else { fatalError() }

        // TODO: Distinguish between integers and decimals

        let format = "%i"

        if newValue >= max
        {
            textField.text = String(format: format, Int(max))
            model?.value = max
            slider.value = max
        }
        else if newValue <= min
        {
            textField.text = String(format: format, Int(min))
            model?.value = min
            slider.value = min
        }
        else
        {
            model?.value = newValue
            slider.value = newValue
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        guard let text = textField.text else { return true }
//        guard let newRange = Range<String.Index>(range, in: text) else { return true }
//        guard let newString = textField.text?.replacingCharacters(in: newRange, with: string) else { return true }
//        guard let newValue = Float(newString) else { return true }
//
//        guard let min = model?.min, let max = model?.max else { fatalError() }
//
//        // TODO: Distinguish between integers and decimals
//
//        let format = "%i"
//
//        if newValue >= max
//        {
//            textField.text = String(format: format, Int(max))
//            model?.value = max
//            slider.value = max
//            return false
//        }
//        else if newValue <= min
//        {
//            textField.text = String(format: format, Int(min))
//            model?.value = min
//            slider.value = min
//            return false
//        }
//        else
//        {
//            model?.value = newValue
//            slider.value = newValue
//        }
        
        return true
    }
}
