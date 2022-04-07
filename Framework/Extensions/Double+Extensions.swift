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
    
    static func percentDelta(a: Double, b: Double, minimum: Double, maximum: Double) -> Double
    {
        // Naive average based delta
//        let delta = abs(b - a)
//        let average = (a + b) * 0.5
//        return delta / average

        // More robust absolute based delta (but not perfect
        let delta = abs(b - a)
        let scale = max(maximum - b, b - minimum)

        return 1 - delta / scale
    }
}
