//
//  OrderType.swift
//  Wash
//
//  Created by Joshua Grant on 3/27/22.
//

import Foundation

public enum OrderType: Int16, CaseIterable
{
    case sequential
    case parallel
    case independent
}
