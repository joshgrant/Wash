//
//  ParsingError.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation

enum ParsingError: Error
{
    case noArguments
    case indexOutsideOfArgumentsBounds(Int)
    case argumentDidNotMatchType(Any.Type)
    case invalidConditionType(String)
    case invalidComparisonType(String)
    case invalidSourceValueType(String)
    case invalidEntityType(String)
    
    case workspaceEntityCannotPerformThisOperation
    
    case workspaceFirstEntityIsNot(Any.Type)
    case workspaceHasNoEntities
    case lastResultIndexOutOfBounds(Int)
    
    case flowAmountInvalid(Double)
    
    case noHistory
    case notRunnable
    
    case invalidCommand
}
