//
//  Bundle+Extensions.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

extension Bundle
{
    var activityType: String
    {
        Bundle
            .main
            .infoDictionary?["NSUserActivityTypes"]
            .flatMap { ($0 as? [String])?.first }
            ?? ""
    }
}
