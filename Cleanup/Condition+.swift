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
    func setComparison(_ comparison: ComparisonType, type: String)
    {
        booleanComparisonType = nil
        numberComparisonType = nil
        dateComparisonType = nil

        switch comparison
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
