//
//  SystemDetailResponder.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class SystemDetailResponderContainer: DependencyContainer
{
    // MARK: - Variables
    
    var system: System
    var stream: Stream
    
    // MARK: - Initialization
    
    init(system: System, stream: Stream)
    {
        self.system = system
        self.stream = stream
    }
}

class SystemDetailResponder
{
    // MARK: - Variables
    
    var container: SystemDetailResponderContainer
    
    // MARK: - Initialization
    
    init(container: SystemDetailResponderContainer)
    {
        self.container = container
    }
    
    // MARK: - Functions
    
    @objc func userTouchedUpInsideDuplicate(sender: UIBarButtonItem)
    {
        let message = SystemDetailDuplicatedMessage(system: system)
        container.stream.send(message: message)
    }
    
    @objc func userTouchedUpInsidePin(sender: UIBarButtonItem)
    {
        system.isPinned.toggle()
        let message = EntityPinnedMessage(
            isPinned: system.isPinned,
            entity: system)
        container.stream.send(message: message)
    }
}
