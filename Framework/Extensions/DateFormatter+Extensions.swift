//
//  DateFormatter+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

extension DateFormatter
{
    static let historyCellFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
