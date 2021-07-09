//
//  Date+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

extension Date
{
    func format(with formatter: DateFormatter) -> String
    {
        formatter.string(from: self)
    }
}
