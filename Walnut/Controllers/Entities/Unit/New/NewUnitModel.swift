//
//  NewUnitModel.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class NewUnitModel
{
    var title: String?
    var symbol: String?
    var isBaseUnit: Bool = true
    var relativeTo: Unit?
    
    var valid: Bool
    {
        return title != nil
            && symbol != nil
            && (isBaseUnit || relativeTo != nil)
    }
}
