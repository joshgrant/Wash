//
//  FallbackProtocol.swift
//  Schema
//
//  Created by Joshua Grant on 10/6/20.
//

import Foundation

/// Provides a default value for enum properties, but `default` is reserved so I used `fallback` instead
protocol FallbackProtocol
{
    static var fallback: Self { get }
}
