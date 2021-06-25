//
//  WindowState.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit
import ProgrammaticUI

enum WindowState: String, Codable
{
    case uninitialized
    case initialized
    case keyAndVisible
}

class WindowStateMachine: StateMachine<WindowState>
{
    override func transition(to nextState: WindowState)
    {
        super.transition(to: nextState)
        
        switch nextState
        {
        case .uninitialized:
            break
        case .initialized:
            break
        case .keyAndVisible:
            break
        }
    }
}
