//
//  CompletionType.swift
//  Wash
//
//  Created by Joshua Grant on 3/27/22.
//

import Foundation

public enum CompletionType: Int16, CaseIterable
{
    /// Completed is only based on the current process
    case `self`
    
    /// Completed is based on the completion status of the children as well
    case children
}
