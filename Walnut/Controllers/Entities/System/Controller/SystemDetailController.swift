//
//  SystemDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class SystemDetailController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var system: System
    var responder: SystemDetailResponder
    var router: SystemDetailRouter
    var tableView: SystemDetailTableView
    
    var duplicateBarButtonItem: UIBarButtonItem
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(
        system: System)
    {
        let responder = SystemDetailResponder(system: system)
        
        self.system = system
        self.responder = responder
        self.tableView = SystemDetailTableView(system: system)
        self.router = SystemDetailRouter(system: system)
        
        self.duplicateBarButtonItem = Self.makeDuplicateNavigationItem(responder: responder)
        self.pinBarButtonItem = Self.makePinNavigationItem(system: system, responder: responder)
        
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = system.title
        
        view.embed(tableView)
        
        navigationItem.setRightBarButtonItems(
            [duplicateBarButtonItem, pinBarButtonItem],
            animated: false)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.makeTextCellFirstResponderIfEmpty()
    }
    
    // MARK: - Factory
    
    static func makeDuplicateNavigationItem(responder: SystemDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.userTouchedUpInsideDuplicate(sender:)))
    }
    
    static func makePinNavigationItem(system: System, responder: SystemDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: system.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.userTouchedUpInsidePin(sender:)))
    }
}

extension SystemDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as EntityPinnedMessage:
            handle(m)
        case let m as TextEditCellMessage:
            handle(m)
        case let m as SectionHeaderAddMessage:
            handle(m)
        default:
            break
        }
    }
    
    func handle(_ message: TextEditCellMessage)
    {
        if message.entity == system
        {
            title = message.title
            system.title = message.title
            system.managedObjectContext?.quickSave()
        }
        else
        {
            tableView.shouldReload = true
        }
    }
    
    func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == system else { return }
        
        let pinned = message.isPinned
        
        pinBarButtonItem.image = pinned
            ? Icon.pinFill.getImage()
            : Icon.pin.getImage()
        
        system.isPinned = pinned
        system.managedObjectContext?.quickSave()
    }
    
    private func handle(_ message: SectionHeaderAddMessage)
    {
        guard message.entityToAddTo == system else { return }
        guard let context = system.managedObjectContext else { return }
        
        let entity = message.entityType.init(context: context)
        
        switch entity
        {
        case let s as Stock:
            system.addToStocks(s)
            router.route(to: .stockDetail(stock: s), completion: nil)
        case let f as TransferFlow:
            system.addToFlows(f)
            router.route(to: .transferFlowDetail(flow: f), completion: nil)
        case let e as Event:
            system.addToEvents(e)
            router.route(to: .eventDetail(event: e), completion: nil)
        case let n as Note:
            system.addToNotes(n)
            router.route(to: .noteDetail(note: n), completion: nil)
        default:
            break
        }
    }
}
