//
//  NewStateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 7/16/21.
//

import Foundation

public class NewStateModel: Unique
{
    public var id = UUID()
    
    var title: String?
    
    // These can be converted to percents/ints if necessary
    var from: Double?
    var to: Double?
}
