//
//  TransitionType.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation

public enum TransitionType
{
    case continuous
    case stateMachine
    
    var title: String
    {
        switch self
        {
        case .continuous: return "Continuous".localized
        case .stateMachine: return "State Machine".localized
        }
    }
}
