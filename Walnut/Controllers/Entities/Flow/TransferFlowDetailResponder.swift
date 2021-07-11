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
    
    // MARK: - Initialization
    
    init(flow: TransferFlow)
    {
        self.flow = flow
    }
    
    @objc func pinButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        flow.isPinned.toggle()
        
        let message = EntityPinnedMessage(
            isPinned: flow.isPinned,
            entity: flow)
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    @objc func runButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        print("RUN TAPPED")
    }
}
