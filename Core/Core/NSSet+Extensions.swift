//
//  NSSet+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public extension NSSet
{
    func toArray<T>() -> [T]
    {
        self.compactMap { $0 as? T }
    }
}
