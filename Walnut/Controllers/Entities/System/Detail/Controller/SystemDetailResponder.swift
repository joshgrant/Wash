//
//  SystemDetailResponder.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

protocol SystemDetailResponderFactory: Factory
{
    func makeResponder() -> SystemDetailResponder
}

class SystemDetailResponderContainer: Container
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

extension SystemDetailResponderContainer: SystemDetailResponderFactory
{
    func makeResponder() -> SystemDetailResponder
    {
        .init(container: self)
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
        let message = SystemDetailDuplicatedMessage(system: container.system)
        container.stream.send(message: message)
    }
    
    @objc func userTouchedUpInsidePin(sender: UIBarButtonItem)
    {
        container.system.isPinned.toggle()
        let message = EntityPinnedMessage(
            isPinned: container.system.isPinned,
            entity: container.system)
        container.stream.send(message: message)
    }
}
