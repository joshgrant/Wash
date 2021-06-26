//
//  SystemDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class SystemDetailController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    var tableView: TableView<SystemDetailTableViewModel>
    var tableViewModel: SystemDetailTableViewModel
    
    var system: System
    var responder: SystemDetailResponder
    var router: SystemDetailRouter
    var textFieldDelegate: SystemDetailControllerTextFieldDelegate
    
    var duplicateBarButtonItem: UIBarButtonItem
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(
        system: System,
        navigationController: NavigationController)
    {
        let textFieldDelegate = SystemDetailControllerTextFieldDelegate()
        
        let tableViewModel = SystemDetailTableViewModel(
            system: system,
            navigationController: navigationController,
            delegate: textFieldDelegate)
        
        let responder = SystemDetailResponder(system: system)
        
        self.system = system
        self.textFieldDelegate = textFieldDelegate
        self.tableViewModel = tableViewModel
        self.tableView = TableView(model: tableViewModel)
        self.responder = responder
        self.router = SystemDetailRouter()
        
        self.duplicateBarButtonItem = Self.makeDuplicateNavigationItem(responder: responder)
        self.pinBarButtonItem = Self.makePinNavigationItem(system: system, responder: responder)
        
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = system.title
        
        view.embed(tableView)
        
        navigationItem.setRightBarButtonItems(
            [duplicateBarButtonItem, pinBarButtonItem],
            animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        makeTextCellFirstResponderIfEmpty()
    }
    
    func makeTextCellFirstResponderIfEmpty()
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        guard let textCell = cell as? TextEditCell else { return }
        
        if let text = textCell.textField.text
        {
            if text.count > 0 { return }
        }
        
        textCell.textField.becomeFirstResponder()
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
        case let x as SystemDetailTitleEditedMessage:
            handleSystemDetailTitleEditMessage(x)
        case let x as SystemDetailPinnedMessage:
            handleSystemDetailPinnedMessage(x)
        default:
            break
        }
    }
    
    func handleSystemDetailTitleEditMessage(_ message: SystemDetailTitleEditedMessage)
    {
        title = message.title
        system.title = message.title
    }
    
    func handleSystemDetailPinnedMessage(_ message: SystemDetailPinnedMessage)
    {
        let pinned = message.isPinned
        
        pinBarButtonItem.image = pinned
            ? Icon.pinFill.getImage()
            : Icon.pin.getImage()
    }
}
