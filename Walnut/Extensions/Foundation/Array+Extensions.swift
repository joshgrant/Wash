//
//  Array+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

extension Array where Element: Hashable
{
    func uniques() -> [Element]
    {
        return Array(Set<Element>(self))
    }
}
