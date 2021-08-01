//
//  Task+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation

extension Task: Named {}

extension Task
{
    var completionType: CompletionType
    {
        get {
            CompletionType(rawValue: completionTypeRaw)!
        }
        set {
            completionTypeRaw = newValue.rawValue
        }
    }
    
    var completionOrderType: OrderType
    {
        get {
            OrderType(rawValue: completionOrderTypeRaw)!
        }
        set {
            completionOrderTypeRaw = newValue.rawValue
        }
    }
}
