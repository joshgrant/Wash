//
//  Int+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public extension Int
{
    @inlinable func map<T>(_ transform: () throws -> T) rethrows -> [T]
    {
        try Array(repeating: (), count: self).map {
            try transform()
        }
    }
}
