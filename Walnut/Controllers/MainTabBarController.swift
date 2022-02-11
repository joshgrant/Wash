//
//  MainTabBarController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class MainTabBarController: TabBarController
{
    override func handle(command: Command)
    {
        switch command.rawString
        {
        case "dashboard":
            selectedIndex = 0
        case "library":
            selectedIndex = 1
        default:
            activeTab.handle(command: command)
        }
        
        view?.draw()
    }
}
