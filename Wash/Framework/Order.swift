//
//  Order.swift
//  Core
//
//  Created by Joshua Grant on 10/3/20.
//

import Foundation

public enum OrderType: Int16, CaseIterable
{
    case sequential
    case parallel
    case independent
}

extension OrderType
{
    static func random() -> OrderType
    {
        allCases.randomElement()!
    }
}
