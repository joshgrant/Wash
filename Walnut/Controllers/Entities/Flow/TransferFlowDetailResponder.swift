//
//  TransferFlowDetailResponder.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailResponder
{
    // MARK: - Variables
    
    var flow: TransferFlow
    var stream: Stream
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, stream: Stream)
    {
        self.flow = flow
        self.stream = stream
    }
    
    @objc func pinButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        flow.isPinned.toggle()
        
        let message = EntityPinnedMessage(
            isPinned: flow.isPinned,
            entity: flow)
        stream.send(message: message)
    }
    
    @objc func runButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        print("RUN TAPPED")
    }
}
