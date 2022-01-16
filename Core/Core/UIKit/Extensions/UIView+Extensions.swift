//
//  UIView+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

public extension UIView
{
    typealias Constraint = NSLayoutConstraint
    typealias Constraints = (
        top: Constraint,
        right: Constraint,
        bottom: Constraint,
        left: Constraint)

    @discardableResult func embed(
        _ view: UIView,
        padding: UIEdgeInsets = .zero,
        bottomPriority: UILayoutPriority = .required,
        rightPriority: UILayoutPriority = .required) -> Constraints
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        let top = view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top)
        let right = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding.right)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding.bottom)
        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left)
        
        bottom.priority = bottomPriority
        right.priority = rightPriority
        
        NSLayoutConstraint.activate([top, right, bottom, leading])
        
        return (top, right, bottom, leading)
    }
    
    func set(width: CGFloat? = nil, height: CGFloat? = nil)
    {
        if let width = width
        {
            setAttribute(attribute: .width, value: width)
        }
        
        if let height = height
        {
            setAttribute(attribute: .height, value: height)
        }
    }
    
    func setAttribute(attribute: Constraint.Attribute, value: CGFloat)
    {
        Constraint.activate(
            [
                Constraint(
                    item: self,
                    attribute: attribute,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: value)
            ]
        )
    }
    
    func setLowCompressionResistanceForAxis(_ axis: NSLayoutConstraint.Axis)
    {
        setContentCompressionResistancePriority(.defaultLow, for: axis)
    }
}
