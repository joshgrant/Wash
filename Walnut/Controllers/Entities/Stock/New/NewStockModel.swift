//
//  NewStockModel.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

// Maybe some sort of component architecture for this model?

class NewStockModel
{
    var title: String?
    var unit: Unit?
    var previouslyBoolean: Bool = true
    var stockType = ValueType.boolean
    {
        willSet
        {
            previouslyBoolean = (stockType == .boolean)
        }
    }
    
    var isStateMachine: Bool = false
    
    var currentBool: Bool?
    var idealBool: Bool?
    
    var currentDouble: Double?
    var idealDouble: Double?
    
    var currentState: NewStateModel?
    var idealState: NewStateModel?
    
    var minimum: Double?
    var maximum: Double?
    
    var states: [NewStateModel] = []
    
    var validForNewStock: Bool
    {
        return title != nil
            && unit != nil
    }
    
    var validForPercentCurrentIdeal: Bool
    {
        currentDouble != nil && idealDouble != nil
    }
    
    var validForMinMax: Bool
    {
        minimum != nil && maximum != nil
    }
    
    var validForStates: Bool
    {
        for state in states
        {
            if state.title == nil { return false }
            if state.from == nil { return false }
            if state.to == nil { return false }
        }
        
        return true
    }
    
    var validForCurrentIdeal: Bool
    {
        if stockType == .boolean
        {
            return true
        }
        else if isStateMachine
        {
            return currentState != nil && idealState != nil
        }
        else
        {
            return validForPercentCurrentIdeal
        }
    }
}
