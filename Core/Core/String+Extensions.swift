//
//  String+Extensions.swift
//  Core
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public extension String
{
    public var localized: String
    {
        NSLocalizedString(self, comment: "")
    }
    
    public func insertSpacesBetweenCamelCaseWords() -> String
    {
        var output: String = ""
        
        for char in self
        {
            if char.isUppercase
            {
                output += " "
            }
            output += String(char)
        }
        
        return output.trimmingCharacters(in: .whitespaces)
    }
    
    public func pluralize() -> String
    {
        return self + "s"
    }
}
