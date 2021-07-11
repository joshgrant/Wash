//
//  SystemDetailResponder.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class SystemDetailResponder
{
    // MARK: - Variables
    
    var system: System
    
    // MARK: - Initialization
    
    init(system: System)
    {
        self.system = system
    }
    
    // MARK: - Functions
    
    @objc func userTouchedUpInsideDuplicate(sender: UIBarButtonItem)
    {
        let message = SystemDetailDuplicatedMessage(system: system)
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    @objc func userTouchedUpInsidePin(sender: UIBarButtonItem)
    {
        system.isPinned.toggle()
        let message = EntityPinnedMessage(
            isPinned: system.isPinned,
            entity: system)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
