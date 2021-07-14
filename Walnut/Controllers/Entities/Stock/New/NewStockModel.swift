//
//  NewStockModel.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class NewStockModel
{
    var title: String?
    var unit: Unit?
    var stockType = ValueType.boolean
    var isStateMachine: Bool = false
    
    var currentBool: Bool?
    var idealBool: Bool?
    
    var currentDouble: Double?
    var idealDouble: Double?
    
    var minimum: Double?
    var maximum: Double?
    
    var validForNewStock: Bool
    {
        return title != nil
            && unit != nil
    }
    
    var validForPercentCurrentIdeal: Bool
    {
        currentDouble != nil && idealDouble != nil
    }
}
