//
//  View.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation

protocol View
{
    func display()
    func handle(input: String)
    func handle(section: Int?, row: Int?, command: String?)
}

extension View
{
    func handle(input: String)
    {
        var section: Int?
        var row: Int?
        var command: String?
        
        let sectionRowRange = input.range(
            of: #"[0-9]\.[0-9]"#,
            options: .regularExpression)
        
        let rowRange = input.range(of: #"[0-9]"#, options: .regularExpression)
        
        let commandRange = input.range(
            of: #"[A-Za-z]+"#,
            options: .regularExpression)
        
        if let range = sectionRowRange
        {
            let number = input[range]
            let numbers = number.split(separator: ".")
            section = Int(String(numbers.first ?? ""))
            row = Int(String(numbers.last ?? ""))
        }
        else if let range = rowRange
        {
            let number = input[range]
            row = Int(String(number))
        }
        
        if let range = commandRange
        {
            command = String(input[range])
        }
        
        handle(section: section, row: row, command: command)
    }
}
