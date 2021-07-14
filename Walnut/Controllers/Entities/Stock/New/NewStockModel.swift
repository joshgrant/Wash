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
    
    var minimum: Double = 0
    var maximum: Double = 100
    
    var valid: Bool
    {
        return title != nil
            && unit != nil
    }
}
