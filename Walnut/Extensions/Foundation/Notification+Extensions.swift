//
//  Notification+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/19/21.
//

import Foundation
import UIKit

extension Notification
{
    var keyboardFrame: CGRect
    {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
    }
    
    var animationOptions: UIView.AnimationOptions
    {
        guard let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else
        {
            return .curveEaseInOut
        }
        
        return UIView.AnimationOptions(rawValue: curve.uintValue)
    }
    
    var animationDuration: TimeInterval
    {
        (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    }
}
