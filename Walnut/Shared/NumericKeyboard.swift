//
//  NumericKeyboard.swift
//  Walnut
//
//  Created by Joshua Grant on 7/18/21.
//

import Foundation
import UIKit

protocol NumericKeyboardDelegate: AnyObject
{
    func toggleSign(keyboard: NumericKeyboard)
    func setInfinity(keyboard: NumericKeyboard)
    func enter(keyboard: NumericKeyboard)
}

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
    
    weak var target: UITextInput?
    weak var delegate: NumericKeyboardDelegate?
    
    var longPressGesture: UILongPressGestureRecognizer
    var panGesture: UIPanGestureRecognizer
    
    var infinity: Bool = false
    var negative: Bool = false
    
    var dragging: Bool = false
    var dragged: Bool = false
    
    var zeroButton = UIButton(type: .custom)
    var oneButton = UIButton(type: .custom)
    var twoButton = UIButton(type: .custom)
    var threeButton = UIButton(type: .custom)
    var fourButton = UIButton(type: .custom)
    var fiveButton = UIButton(type: .custom)
    var sixButton = UIButton(type: .custom)
    var sevenButton = UIButton(type: .custom)
    var eightButton = UIButton(type: .custom)
    var nineButton = UIButton(type: .custom)
    var negativeButton = UIButton(type: .custom)
    var infinityButton = UIButton(type: .custom)
    var deleteButton = UIButton(type: .custom)
    var returnButton = UIButton(type: .custom)
    
    var backgroundImage = UIImage(named: "NumericKeyboardButton")
    var highlightImage = UIImage(named: "NumericKeyboardHighlightButton")
    var disabledImage = UIImage(named: "NumericKeyboardDisabledButton")
    
    // MARK: - Initialization
    
    init()
    {
        self.longPressGesture = UILongPressGestureRecognizer()
        self.panGesture = UIPanGestureRecognizer()
        
        super.init(frame: .zero)
        
        longPressGesture.addTarget(self, action: #selector(handleLongPress(_:)))
        longPressGesture.delegate = self
        
        panGesture.addTarget(self, action: #selector(panGestureDidPan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self

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
        topStackView.alignment = .fill
        topStackView.distribution = .fillEqually
        topStackView.spacing = 6
        
        let upperMiddleStackView = UIStackView(arrangedSubviews: [fourButton, fiveButton, sixButton])
        upperMiddleStackView.alignment = .fill
        upperMiddleStackView.distribution = .fillEqually
        upperMiddleStackView.spacing = 6
        
        let lowerMiddleStackView = UIStackView(arrangedSubviews: [sevenButton, eightButton, nineButton])
        lowerMiddleStackView.alignment = .fill
        lowerMiddleStackView.distribution = .fillEqually
        lowerMiddleStackView.spacing = 6
        
        let leftAccessoryStackView = UIStackView(arrangedSubviews: [negativeButton, infinityButton])
        leftAccessoryStackView.alignment = .fill
        leftAccessoryStackView.distribution = .fillEqually
        leftAccessoryStackView.spacing = 6
        
        let rightAccessoryStackView = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        rightAccessoryStackView.alignment = .fill
        rightAccessoryStackView.distribution = .fillEqually
        rightAccessoryStackView.spacing = 6
        
        let bottomStackView = UIStackView(arrangedSubviews: [leftAccessoryStackView, zeroButton, rightAccessoryStackView])
        bottomStackView.alignment = .fill
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
        mainStackView.spacing = 6
        
        let padding = UIEdgeInsets(top: 6, left: 6, bottom: 4, right: 6)
        
        embed(mainStackView, padding: padding) // Embed with contentInsets
        
        addGestureRecognizer(longPressGesture)
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        panGesture.removeTarget(self, action: #selector(panGestureDidPan(_:)))
    }
    
    // MARK: - Functions
    
    private func configure(button: UIButton, tag: Int)
    {
        button.tag = tag
        
        if let title = title(for: tag)
        {
            button.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 25, weight: .regular)
            button.setTitle(title, for: .normal)
            
            button.setBackgroundImage(backgroundImage, for: .normal)
            button.setBackgroundImage(highlightImage, for: .highlighted)
            button.setBackgroundImage(disabledImage, for: .disabled)
            
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.clear, for: .disabled)
        }
        else if let icon = icon(for: tag)
        {
            button.setImage(icon.getImage(), for: .normal)
            button.tintColor = .darkGray
        }
        
        button.addTarget(self, action: #selector(buttonDidTouchUpInside(_:)), for: .touchUpInside)
    }
    
    private func updateButtonsToPanning(_ panning: Bool)
    {
        if panning
        {
            // add placeholder view...
            buttons().forEach { button in
                button.isEnabled = false
            }
        }
        else
        {
            buttons().forEach { button in
                button.isEnabled = true
            }
        }
    }
    
    // MARK: - Functions
    
    @objc func buttonDidTouchUpInside(_ sender: UIButton)
    {
        let action = action(for: sender.tag)
        print("Action: \(action)")
        playClick()
        
        switch action
        {
        case .delete:
            infinity = false
            target?.deleteBackward()
        case .enter:
            delegate?.enter(keyboard: self)
        case .infinity:
            delegate?.setInfinity(keyboard: self)
            infinity = true
        case .negative:
            negative.toggle()
            configure(button: negativeButton, tag: 10)
            delegate?.toggleSign(keyboard: self)
        case .number(let value):
            
            if infinity
            {
                target?.deleteBackward()
                infinity = false
            }
            
            target?.insertText("\(value)")
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer)
    {
        let location = sender.location(in: self)
        
        switch sender.state
        {
        case .began:
            dragging = true
            updateButtonsToPanning(true)
            target?.beginFloatingCursor?(at: location)
        case .ended, .failed, .cancelled:
            if !dragged
            {
                updateButtonsToPanning(false)
                target?.endFloatingCursor?()
                dragging = false
            }
        default:
            break
        }
    }
    
    @objc func panGestureDidPan(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: self)
        
        switch sender.state
        {
        case .changed:
            dragged = true
            target?.updateFloatingCursor?(at: location)
        case .ended, .failed, .cancelled:
            updateButtonsToPanning(false)
            target?.endFloatingCursor?()
            dragging = false
            dragged = false
        case .possible:
            break
        case .began:
            guard dragging else { return }
            target?.beginFloatingCursor?(at: location)
        @unknown default:
            target?.endFloatingCursor?()
        }
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
        case 10: return negative ? .add : .negative
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

extension NumericKeyboard: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}
