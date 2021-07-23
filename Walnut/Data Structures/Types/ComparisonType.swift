//
//  ComparisonType.swift
//  Core
//
//  Created by Joshua Grant on 10/2/20.
//

import Foundation

public enum ComparisonType: Int16, CaseIterable, Random
{
    case boolean
    case date
    case string
    case number
}

public enum BooleanComparisonType: Int16, CaseIterable, Random
{
    case equal
    case notEqual
}

public enum DateComparisonType: Int16, CaseIterable, Random
{
    case after
    case before
//    case inTheLast
//    case notInTheLast
}

public enum StringComparisonType: Int16, CaseIterable, Random
{
    case beginsWith
    case endsWith
    case contains
    case doesNotContain
}

public enum NumberComparisonType: Int16, CaseIterable, Random
{
    case equal
    case notEqual
    case greaterThan
    case lessThan
    case greaterThanOrEqual
    case lessThanOrEqual
//    case inTheRange
}
