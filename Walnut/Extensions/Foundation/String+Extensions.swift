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

public extension String
{
    // MARK: - Unsorted
    
    static let edit = "Edit".localized
    
    // MARK: - Section Headers
    
    static let info = "Info".localized
    static let events = "Events".localized
    static let history = "History".localized
    static let pinned = "Pinned".localized
    static let flows = "Flows".localized
    static let forecast = "Forecast".localized
    static let priority = "Priority".localized
    static let valueType = "Value Type".localized
    static let transitionType = "Transition Type".localized
    static let references = "References".localized
    static let links = "Links".localized
    static let ideal = "Ideal".localized
    static let current = "Current".localized
    static let states = "States".localized
    static let constraints = "Constraints".localized
    static let goal = "Goal".localized
    
    static let suggested = "Suggested".localized
}
