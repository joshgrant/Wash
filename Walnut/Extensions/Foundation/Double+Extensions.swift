//
//  Double+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/23/21.
//

import Foundation

extension Double
{
    func constrained(min: Double, max: Double) -> Double 
    {
        Double.minimum(Double.maximum(min, self), max)
    }
}
