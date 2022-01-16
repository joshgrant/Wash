//
//  Double+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/23/21.
//

import Foundation

public extension Double
{
    func constrained(min: Double, max: Double) -> Double 
    {
        Double.minimum(Double.maximum(min, self), max)
    }
    
    static func percentDelta(a: Double, b: Double, minimum: Double, maximum: Double) -> Double
    {
        guard a <= maximum, b <= maximum, a >= minimum, b >= minimum, maximum >= minimum else { preconditionFailure() }
        
        let delta = abs(b - a)
        let scale = max(maximum - b, b - minimum)
        
        return 1 - delta / scale
    }
    
    static func veryRandom() -> Double
    {
        Double.random(in: -10e10 ... 10e10)
    }
}
