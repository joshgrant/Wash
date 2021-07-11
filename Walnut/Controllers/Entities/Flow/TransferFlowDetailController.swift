//
//  TransferFlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var flow: TransferFlow
    
    var router: TransferFlowDetailRouter
    var responder: TransferFlowDetailResponder
    
    weak var context: Context?
    
    var tableView: TransferFlowDetailTableView
    
    var pinButton: UIBarButtonItem
    var runButton: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, context: Context?)
    {
        let responder = TransferFlowDetailResponder(flow: flow)
        
        self.flow = flow
        
        self.router = TransferFlowDetailRouter(flow: flow,context: context)
        self.responder = responder
        self.tableView = TransferFlowDetailTableView(flow: flow)
        
        self.pinButton = Self.makePinButton(flow: flow, responder: responder)
        self.runButton = Self.makeRunButton(responder: responder)
        
        self.context = context
        
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = flow.title
        
        view.embed(tableView)
        
        navigationItem.setRightBarButtonItems([pinButton, runButton], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Factory
    
    static func makePinButton(flow: TransferFlow, responder: TransferFlowDetailResponder) -> UIBarButtonItem
    {
        let icon: Icon = flow.isPinned ? .pinFill : .pin
        
        let actionClosure = ActionClosure { sender in
            flow.isPinned.toggle()
            let message = EntityPinnedMessage(
                isPinned: flow.isPinned,
                entity: flow)
            AppDelegate.shared.mainStream.send(message: message)
        }
        
        return BarButtonItem(
            image: icon.getImage(),
            style: .plain,
            actionClosure: actionClosure)
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

extension TransferFlowDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TextEditCellMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        case let m as ToggleCellMessage:
            handle(m)
        case let m as EntityPinnedMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        if message.entity == flow
        {
            title = message.title
            flow.title = message.title
            flow.managedObjectContext?.quickSave()
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard let stock = message.entity as? Stock else { return }
        
        switch router.presentedDestination
        {
        case .stockFrom:
            flow.from = stock
        case .stockTo:
            flow.to = stock
        default:
            break
        }
        
        flow.managedObjectContext?.quickSave()
        
        tableView.shouldReload = true
    }
    
    private func handle(_ message: ToggleCellMessage)
    {
        switch message.selectionIdentifier
        {
        case .requiresUserCompletion(let state):
            flow.requiresUserCompletion = state
        default:
            break
        }
    }
    
    private func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == flow else { return }
        
        let pinned = message.isPinned
        let icon: Icon = pinned ? .pinFill : .pin
        
        pinButton.image = icon.getImage()
        flow.isPinned = pinned
        flow.managedObjectContext?.quickSave()
    }
}
