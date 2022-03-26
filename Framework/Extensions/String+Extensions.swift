//
//  String+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

public extension String
{
    var localized: String
    {
        NSLocalizedString(self, comment: "")
    }
}
