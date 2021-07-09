//
//  TransferFlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailController: UIViewController
{
    // MARK: - Variables
    
    var flow: TransferFlow
    
    var router: TransferFlowDetailRouter
    var responder: TransferFlowDetailResponder
    var tableViewManager: TransferFlowDetailTableViewManager
    
    var pinButton: UIBarButtonItem
    var runButton: UIBarButtonItem
    
    static let stream: Stream = {
        let stream = Stream(identifier: .transferFlow)
        AppDelegate.shared.mainStream.add(substream: stream)
        return stream
    }()
    
    // MARK: - Initialization
    
    init(flow: TransferFlow)
    {
        let responder = TransferFlowDetailResponder(flow: flow)
        
        self.flow = flow
        
        self.router = TransferFlowDetailRouter()
        self.responder = responder
        self.tableViewManager = TransferFlowDetailTableViewManager()
        
        self.pinButton = Self.makePinButton(flow: flow, responder: responder)
        self.runButton = Self.makeRunButton(responder: responder)
        
        super.init(nibName: nil, bundle: nil)
        
        view.embed(tableViewManager.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Factory
    
    static func makePinButton(flow: TransferFlow, responder: TransferFlowDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: flow.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.pinButtonDidTouchUpInside(_:)))
    }
    
    static func makeRunButton(responder: TransferFlowDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.activateFlow.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.runButtonDidTouchUpInside(_:)))
    }
}
