//
//  Condition+Extensions.swift
//  Wash
//
//  Created by Joshua Grant on 3/19/22.
//

import Foundation
import Core

extension Condition
{    
    func setComparison(_ comparison: String, type: String)
    {
        guard let comparisonType = ComparisonType(string: comparison) else
        {
            print("Invalid comparison. Either `bool`, `date`, or `number`")
            return
        }
        
        booleanComparisonType = nil
        numberComparisonType = nil
        dateComparisonType = nil

        switch comparisonType
        {
        case .boolean:
            guard let booleanType = BooleanComparisonType(string: type) else
            {
                print("Invalid boolean type.")
                return
            }
            booleanComparisonType = booleanType
        case .number:
            guard let numberType = NumberComparisonType(string: type) else
            {
                print("Invalid number type/")
                return
            }
            numberComparisonType = numberType
        case .date:
            guard let dateType = DateComparisonType(string: type) else
            {
                print("Invalid date type.")
                return
            }
            dateComparisonType = dateType
        }
    }
}

// MARK: - Utility

extension Condition
{
    static func handleCommand(command: CommandData) -> Bool
    {
        switch command.command
        {
        case "set-comparison":
            guard let condition: Condition = getEntity(from: workspace),
                  let (c, t) = parseTwoStrings(arguments: command.arguments)
            else {
                break
            }
            condition.setComparison(c, type: t)
        case "set-left-hand":
            guard let condition: Condition = getEntity(from: workspace) else { break }
            condition.leftHand = makeSource(from: command.arguments, in: database.context)
        case "set-right-hand":
            guard let condition: Condition = getEntity(from: workspace) else { break }
            condition.rightHand = makeSource(from: command.arguments, in: database.context)
        default:
            return false
        }
        
        return true
    }
}
