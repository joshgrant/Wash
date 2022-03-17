//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 3/5/22.
//

import Foundation

struct Command
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
