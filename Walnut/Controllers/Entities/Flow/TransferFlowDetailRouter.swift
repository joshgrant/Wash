//
//  TransferFlowDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class TransferFlowDetailRouter: Router
{
    enum Destination
    {
        case stockPicker
        case eventDetail(event: Event)
        case historyDetail(history: History)
    }
    
    weak var root: NavigationController?
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .stockPicker:
            print("Route to stock picker")
        case .eventDetail(let event):
            print("Route to event detail: \(event)")
        case .historyDetail(let history):
            print("Route to history: \(history)")
        }
    }
}
