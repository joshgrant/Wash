//
//  TransferFlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowFactory: Factory
{
    
}

class TransferFlowDetailDependencyContainer: DependencyContainer
{
    // MARK: - Variables
    
    var flow: TransferFlow
    var context: Context
    var stream: Stream
    var router: TransferFlowDetailRouter // TransferFlowDetailRouter(flow: flow,context: context)
    var responder: TransferFlowDetailResponder // TransferFlowDetailResponder(flow: container.flow)
    
    // MARK: - Initialization
    
    init(
        flow: TransferFlow,
        context: Context,
        stream: Stream,
        router: TransferFlowDetailRouter? = nil,
        responder: TransferFlowDetailResponder? = nil)
    {
        self.flow = flow
        self.context = context
        self.stream = stream
        self.router = router ?? TransferFlowDetailRouter(container: self)
        self.responder = responder ?? TransferFlowDetailResponder(flow: flow)
    }
}

class TransferFlowDetailController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var container: TransferFlowDetailDependencyContainer
    
    var tableView: TransferFlowDetailTableView
    
    var pinButton: UIBarButtonItem
    var runButton: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(container: TransferFlowDetailDependencyContainer)
    {
        self.container = container
        self.tableView = TransferFlowDetailTableView(flow: container.flow)
        
        self.pinButton = Self.makePinButton(
            flow: container.flow,
            responder: container.responder)
        
        self.runButton = Self.makeRunButton(
            responder: container.responder)
        
        super.init(nibName: nil, bundle: nil)
        
        container.router.delegate = self
        subscribe(to: container.stream)
        
        configureForDisplay()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - Functions
    
    private func configureForDisplay()
    {
        title = container.flow.title
        view.embed(tableView)
        navigationItem.setRightBarButtonItems([pinButton, runButton], animated: false)
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
        if case .flow(let f) = message.selectionIdentifier, f == flow
        {
            title = message.title
            flow.title = message.title
            flow.managedObjectContext?.quickSave()
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard let stock = message.link as? Stock else { return }
        
        switch router.presentedDestination
        {
        case .stockFrom:
            flow.from = stock
            stock.addToOutflows(flow)
        case .stockTo:
            flow.to = stock
            stock.addToInflows(flow)
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
