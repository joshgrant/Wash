//
//  String+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation

public extension String
{
    func insertSpacesBetweenCamelCaseWords() -> String
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
    
    func pluralize() -> String
    {
        return self + "s"
    }
}
