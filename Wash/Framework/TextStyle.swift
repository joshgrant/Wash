//
//  TextStyle.swift
//  Core
//
//  Created by Joshua Grant on 10/2/20.
//

import Foundation

public enum TextStyle: Int16, CaseIterable
{
    case bold
    case italic
    case boldItalic
    case normal
}

extension TextStyle: FallbackProtocol
{
    static let fallback: TextStyle = .normal
}

extension TextStyle
{
    static func random() -> TextStyle
    {
        allCases.randomElement()!
    }
}
