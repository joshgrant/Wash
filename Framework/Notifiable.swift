//
//  Notifiable.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation

protocol Notifiable: AnyObject
{
    func handleNotifications(_ shouldHandle: Bool)
    func startObservingNotifications()
    func stopObservingNotifications()
}

extension Notifiable
{
    func handleNotifications(_ shouldHandle: Bool)
    {
        if shouldHandle
        {
            startObservingNotifications()
        }
        else
        {
            stopObservingNotifications()
        }
    }
    
    func stopObservingNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
}
