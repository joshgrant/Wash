//
//  Random.swift
//  Walnut
//
//  Created by Joshua Grant on 7/23/21.
//

import Foundation

protocol Random
{
    static func random() -> Self
}

extension Random where Self: CaseIterable
{
    static func random() -> Self
    {
        allCases.randomElement()!
    }
}
