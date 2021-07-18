//
//  NumericKeyboard.swift
//  Walnut
//
//  Created by Joshua Grant on 7/18/21.
//

import Foundation
import UIKit

class NumericKeyboard: UIView
{
    // MARK: - Defined types
    
    enum Action
    {
        case number(value: Int)
        case negative
        case infinity
        case delete
        case enter
    }
    
    // MARK: - Variables
    
    var zeroButton = UIButton()
    var oneButton = UIButton()
    var twoButton = UIButton()
    var threeButton = UIButton()
    var fourButton = UIButton()
    var fiveButton = UIButton()
    var sixButton = UIButton()
    var sevenButton = UIButton()
    var eightButton = UIButton()
    var nineButton = UIButton()
    var negativeButton = UIButton()
    var infinityButton = UIButton()
    var deleteButton = UIButton()
    var returnButton = UIButton()
    
    // MARK: - Initialization
    
    init()
    {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 216)
        super.init(frame: frame)
        
        configure(button: zeroButton, tag: 0)
        configure(button: oneButton, tag: 1)
        configure(button: twoButton, tag: 2)
        configure(button: threeButton, tag: 3)
        configure(button: fourButton, tag: 4)
        configure(button: fiveButton, tag: 5)
        configure(button: sixButton, tag: 6)
        configure(button: sevenButton, tag: 7)
        configure(button: eightButton, tag: 8)
        configure(button: nineButton, tag: 9)
        configure(button: negativeButton, tag: 10) // Negative
        configure(button: infinityButton, tag: 11) //Infinity
        configure(button: deleteButton, tag: 12) // Delete
        configure(button: returnButton, tag: 13) // Return
        
        let topStackView = UIStackView(arrangedSubviews: [oneButton, twoButton, threeButton])
        topStackView.alignment = .center
        topStackView.distribution = .fillEqually
        topStackView.spacing = 6
        
        let upperMiddleStackView = UIStackView(arrangedSubviews: [fourButton, fiveButton, sixButton])
        upperMiddleStackView.alignment = .center
        upperMiddleStackView.distribution = .fillEqually
        upperMiddleStackView.spacing = 6
        
        let lowerMiddleStackView = UIStackView(arrangedSubviews: [sevenButton, eightButton, nineButton])
        lowerMiddleStackView.alignment = .center
        lowerMiddleStackView.distribution = .fillEqually
        lowerMiddleStackView.spacing = 6
        
        let leftAccessoryStackView = UIStackView(arrangedSubviews: [negativeButton, infinityButton])
        leftAccessoryStackView.alignment = .center
        leftAccessoryStackView.distribution = .fillEqually
        leftAccessoryStackView.spacing = 6
        
        let rightAccessoryStackView = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        rightAccessoryStackView.alignment = .center
        rightAccessoryStackView.distribution = .fillEqually
        rightAccessoryStackView.spacing = 6
        
        let bottomStackView = UIStackView(arrangedSubviews: [leftAccessoryStackView, zeroButton, rightAccessoryStackView])
        bottomStackView.alignment = .center
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 6
        
        let mainStackView = UIStackView(arrangedSubviews: [
                                            topStackView,
                                            upperMiddleStackView,
                                            lowerMiddleStackView,
                                            bottomStackView])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
//        mainStackView.spacing = 4
        
        embed(mainStackView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(button: UIButton, tag: Int)
    {
        button.tag = tag
        
        if let title = title(for: tag)
        {
            button.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 25, weight: .regular)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .white
            
            // TODO: Validate best practices
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.layer.shadowRadius = 0
            button.layer.shadowColor = UIColor(white: 0.0, alpha: 0.25).cgColor
            
            button.setTitleColor(.black, for: .normal)
        }
        else if let icon = icon(for: tag)
        {
            button.setImage(icon.getImage(), for: .normal)
            button.tintColor = .darkGray
        }
        
        button.addTarget(self, action: #selector(buttonDidTouchUpInside(_:)), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    @objc func buttonDidTouchUpInside(_ sender: UIButton)
    {
        let action = action(for: sender.tag)
        print("Action: \(action)")
    }
    
    // MARK: - Utility
    
    private func playClick()
    {
        UIDevice.current.playInputClick()
    }
    
    private func buttons() -> [UIButton]
    {
        [
            oneButton,
            twoButton,
            threeButton,
            fourButton,
            fiveButton,
            sixButton,
            sevenButton,
            eightButton,
            nineButton,
            negativeButton,
            infinityButton,
            zeroButton,
            deleteButton,
            returnButton
        ]
    }
    
    private func title(for tag: Int) -> String?
    {
        switch tag
        {
        case 0: return "0".localized
        case 1: return "1".localized
        case 2: return "2".localized
        case 3: return "3".localized
        case 4: return "4".localized
        case 5: return "5".localized
        case 6: return "6".localized
        case 7: return "7".localized
        case 8: return "8".localized
        case 9: return "9".localized
        default:
            return nil
        }
    }
    
    private func icon(for tag: Int) -> Icon?
    {
        switch tag
        {
        case 10: return .negative
        case 11: return .infinity
        case 12: return .delete
        case 13: return .enter
        default:
            return nil
        }
    }
    
    private func action(for tag: Int) -> Action
    {
        switch tag
        {
        case 10: return .negative
        case 11: return .infinity
        case 12: return .delete
        case 13: return .enter
        default:
            return .number(value: tag)
        }
    }
}

extension NumericKeyboard: UIInputViewAudioFeedback
{
    var enableInputClicksWhenVisible: Bool { true }
}

// UIDevice.playInputClick

//UIInputViewAudioFeedback protocol

// height 216

// cell width: 124
// cell height: 54
