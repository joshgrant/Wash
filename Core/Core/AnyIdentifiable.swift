//
//  AnyIdentifiable.swift
//  Core
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public struct AnyIdentifiable
{
    typealias ID = AnyHashable
    
    var id: ID
}
