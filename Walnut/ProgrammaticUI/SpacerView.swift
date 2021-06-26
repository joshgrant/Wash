//
//  SpacerView.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 9/28/20.
//

import UIKit

open class SpacerView: UIView
{
    // MARK: - Initialization
    
    public init(width: CGFloat? = nil, height: CGFloat? = nil)
    {
        super.init(frame: .init(
                    x: 0,
                    y: 0,
                    width: width ?? 0,
                    height: height ?? 0))
        
        setWidth(width)
        setHeight(height)
    }
    
    public required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setWidth(_ width: CGFloat?)
    {
        if let width = width
        {
            set(width: width)
        }
        else
        {
            setLowCompressionResistanceForAxis(.horizontal)
        }
    }
    
    private func setHeight(_ height: CGFloat?)
    {
        if let height = height
        {
            set(height: height)
        }
        else
        {
            setLowCompressionResistanceForAxis(.vertical)
        }
    }
}
