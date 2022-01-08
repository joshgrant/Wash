//
//  FlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

protocol FlowFactory: Factory
{
    func makeController() -> FlowDetailController
    func makeRouter() -> FlowDetailRouter
    func makeResponder() -> FlowDetailResponder
    func makeTableView() -> TableView<FlowDetailTableViewContainer>
    
    func makePinButton() -> UIBarButtonItem
    func makeRunButton(responder: FlowDetailResponder) -> UIBarButtonItem
}

class FlowDetailContainer: Container
{
    // MARK: - Variables
    
    var flow: Flow
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(
        flow: Flow,
        context: Context,
        stream: Stream)
    {
        self.flow = flow
        self.context = context
        self.stream = stream
    }
}

extension FlowDetailContainer: FlowFactory
{
    func makeController() -> FlowDetailController
    {
        .init(container: self)
    }
    
    func makeRouter() -> FlowDetailRouter
    {
        let container = FlowDetailRouterContainer(
            stream: stream,
            context: context)
        return .init(container: container)
    }
    
    func makeResponder() -> FlowDetailResponder
    {
        return .init(flow: flow, stream: stream)
    }
    
    func makeTableView() -> TableView<FlowDetailTableViewContainer>
    {
        let container = FlowDetailTableViewContainer(
            stream: stream,
            style: .grouped,
            flow: flow)
        return .init(container: container)
    }
    
    func makePinButton() -> UIBarButtonItem
    {
        let icon: Icon = flow.isPinned ? .pinFill : .pin
        
        let actionClosure = ActionClosure { [unowned self] sender in
            self.flow.isPinned.toggle()
            let message = EntityPinnedMessage(
                isPinned: self.flow.isPinned,
                entity: self.flow)
            self.stream.send(message: message)
        }
        
        return BarButtonItem(
            image: icon.image,
            style: .plain,
            actionClosure: actionClosure)
    }
    
    func makeRunButton(responder: FlowDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.activateFlow.image,
            style: .plain,
            target: responder,
            action: #selector(responder.runButtonDidTouchUpInside(_:)))
    }
}

class FlowDetailController: ViewController<FlowDetailContainer>, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var router: FlowDetailRouter
    var responder: FlowDetailResponder
    
    var tableView: TableView<FlowDetailTableViewContainer>
    
    var pinButton: UIBarButtonItem
    var runButton: UIBarButtonItem
    
    // MARK: - Initialization
    
    required init(container: FlowDetailContainer)
    {
        let responder = container.makeResponder()
     
        self.responder = responder
        
        router = container.makeRouter()
        tableView = container.makeTableView()
        pinButton = container.makePinButton()
        runButton = container.makeRunButton(responder: responder)
        
        super.init(container: container)
        router.delegate = self
        subscribe(to: container.stream)
    }
    
    deinit
    {
        unsubscribe(from: container.stream)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = container.flow.title
        view.embed(tableView)
        navigationItem.setRightBarButtonItems([pinButton, runButton], animated: false)
    }
}

extension FlowDetailController: Subscriber
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
        if case .flow(let f) = message.selectionIdentifier, f == container.flow
        {
            title = message.title
            container.flow.unwrappedName = message.title
            container.flow.managedObjectContext?.quickSave()
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
//        guard let stock = message.link as? Stock else { return }
        
        fatalError("We need to know where to add the stock")
        
//        switch router.container
//        {
//        case .stockFrom:
//            container.flow.from = stock
//            stock.addToOutflows(flow)
//        case .stockTo:
//            container.flow.to = stock
//            stock.addToInflows(flow)
//        default:
//            break
//        }
        
//        container.flow.managedObjectContext?.quickSave()
//        
//        tableView.shouldReload = true
    }
    
    private func handle(_ message: ToggleCellMessage)
    {
        switch message.selectionIdentifier
        {
        case .requiresUserCompletion(let state):
            container.flow.requiresUserCompletion = state
        default:
            break
        }
    }
    
    private func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == container.flow else { return }
        
        let pinned = message.isPinned
        let icon: Icon = pinned ? .pinFill : .pin
        
        pinButton.image = icon.image
        container.flow.isPinned = pinned
        container.flow.managedObjectContext?.quickSave()
    }
}
