//
//  CommandData.swift
//  Wash
//
//  Created by Josh Grant on 4/7/22.
//

import Foundation

struct CommandData
{
    var command: String
    var arguments: [String]
    
    init(input: String)
    {
        var command = ""
        var arguments: [String] = []
        
        var word = ""
        var openQuote = false
        
        func assign()
        {
            if command == ""
            {
                command = word
            }
            else
            {
                arguments.append(word)
            }
            
            word = ""
        }
        
        for char in Array(input)
        {
            if char == "\""
            {
                openQuote.toggle()
            }
            
            if !openQuote && char == " "
            {
                assign()
            }
            else
            {
                word.append(char)
            }
        }
        
        assign()
        
        self.command = command
        self.arguments = arguments
    }
}

// MARK: - Parsing

extension CommandData
{
    func getEntityType() -> EntityType?
    {
        guard arguments.count > 0 else
        {
            print("No arguments.")
            return nil
        }
        
        return EntityType(string: arguments[0])
    }
    
    func getName(startingAt index: Int = 0) -> String?
    {
        guard arguments.count > index else
        {
            return nil
        }
        
        return arguments[index...].joined(separator: " ")
    }
    
    func getIndex() -> Int?
    {
        guard var first = arguments.first else
        {
            print("No arguments.")
            return nil
        }
        
        // For the cases where we want a wild-card to distinguish it from a number input
        if first.first == "$"
        {
            first.removeFirst()
        }
        
        guard let number = Int(first) else
        {
            print("First argument was not an integer.")
            return nil
        }
        
        return number
    }
    
    func getSourceValueType() -> SourceValueType?
    {
        guard let first = arguments.first?.lowercased() else
        {
            print("No arguments.")
            return nil
        }
        
        return SourceValueType(string: first)
    }
    
    func getNumber() -> Double?
    {
        guard let first = arguments.first else
        {
            print("No arguments.")
            return nil
        }
        
        guard let number = Double(first) else
        {
            print("First argument wasn't a number.")
            return nil
        }
        
        return number
    }
    
    func getConditionType() -> ConditionType?
    {
        guard let string = arguments.first else
        {
            print("Please provide a condition type: `all` or `any`")
            return nil
        }
        
        return ConditionType(string)
    }
    
    func getComparisonType() -> ComparisonType?
    {
        guard let string = arguments.first else
        {
            print("Please provide a comparison type: `bool`, `date`, or `number`")
            return nil
        }
        
        return ComparisonType(string: string)
    }
    
    func getArgument(at index: Int) -> String?
    {
        guard arguments.count > index else
        {
            print("Not enough arguments in \(arguments) to get an argument at index \(index)")
            return nil
        }
        
        return arguments[index]
    }
}
