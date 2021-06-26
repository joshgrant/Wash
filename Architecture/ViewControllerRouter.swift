//
//  ViewControllerRouter.swift
//  Architecture
//
//  Created by Joshua Grant on 6/25/21.
//

import Foundation
import UIKit

class ViewControllerRouter: Router
{
    enum Route
    {
        case secondaryController
    }
    
    var id: UUID = UUID()
    weak var source: UIViewController?
    
    init()
    {
        // TODO: Dependency Injection
        // OR: a property on a subscriber that specifies
        // what it's subscribing to
        subscribe(to: AppDelegate.shared.mainStream)
    }
}

extension ViewControllerRouter: Subscriber
{
    func receive(event: Event)
    {
        switch event.token
        {
        case .buttonPress:
            route(to: .secondaryController)
        default:
            break
        }
    }
    
    func route(to destination: Route)
    {
        switch destination
        {
        case .secondaryController:
            routeToSecondaryController()
        }
    }
    
    func routeToSecondaryController()
    {
        let secondaryController = SecondaryController()
        source?.present(secondaryController, animated: true, completion: nil)
    }
}
