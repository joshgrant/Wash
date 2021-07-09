//
//  String+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

public extension String
{
    var localized: String
    {
        NSLocalizedString(self, comment: "")
    }
    
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
