//
//  NewSystemController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/21/21.
//

import UIKit

protocol NewSystemControllerFactory: Factory
{
    func makeController() -> NewSystemController
    func makeRouter() -> NewSystemControllerRouter
    func makeTableView() -> TableView<NewSystemTableViewBuilder>
    func makeCancelButton(responder: NewSystemControllerResponder) -> UIBarButtonItem
    func makeDoneButton(responder: NewSystemControllerResponder) -> UIBarButtonItem
}

protocol NewSystemControllerContainer: DependencyContainer
{
    var model: NewSystemModel { get set }
    var context: Context { get set }
    var stream: Stream { get set }
}

@objc protocol NewSystemControllerResponder
{
    @objc func cancelButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    @objc func doneButtonDidTouchUpInside(_ sender: UIBarButtonItem)
}

class NewSystemControllerBuilder: NewSystemControllerFactory & NewSystemControllerContainer
{
    // MARK: - Variables
    
    var model: NewSystemModel
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.model = NewSystemModel()
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func makeController() -> NewSystemController
    {
        .init(container: self)
    }
    
    func makeTableView() -> TableView<NewSystemTableViewBuilder>
    {
        let builder = NewSystemTableViewBuilder(
            newSystemModel: model,
            stream: stream,
            style: .grouped)
        return builder.makeTableView()
    }
    
    func makeCancelButton(responder: NewSystemControllerResponder) -> UIBarButtonItem
    {
        let cancel = UIBarButtonItem(systemItem: .cancel)
        cancel.target = responder
        cancel.action = #selector(responder.cancelButtonDidTouchUpInside(_:))
        return cancel
    }
    
    func makeDoneButton(responder: NewSystemControllerResponder) -> UIBarButtonItem
    {
        let done = UIBarButtonItem(systemItem: .done)
        done.target = responder
        done.action = #selector(responder.doneButtonDidTouchUpInside(_:))
        return done
    }
    
    func makeRouter() -> NewSystemControllerRouter
    {
        .init(container: .init())
    }
}

class NewSystemController: ViewController<NewSystemControllerBuilder>, RouterDelegate, NewSystemControllerResponder
{
    // MARK: - Variables
    
    var router: NewSystemControllerRouter
    var tableView: TableView<NewSystemTableViewBuilder>
    
    // MARK: - Initialization
    
    required init(container: NewSystemControllerBuilder)
    {
        self.router = container.makeRouter()
        self.tableView = container.makeTableView()
        super.init(container: container)
        router.delegate = self
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "New System".localized
        
        navigationItem.leftBarButtonItem = container.makeCancelButton(responder: self)
        navigationItem.rightBarButtonItem = container.makeDoneButton(responder: self)
        
        view.embed(tableView)
    }
    
    // MARK: - Responder
    
    @objc func cancelButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        router.routeCancel()
    }
    
    @objc func doneButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        // Get the title of the cell...
        
        // FIXME: Not great to access by index path
        let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextEditCell
        let title = titleCell.textField.text
        
        let system = System(context: container.context)
        
        let symbol = Symbol(context: container.context)
        symbol.name = title
        system.symbolName = symbol
        
        container.context.quickSave()
        
        let message = EntityInsertionMessage(entity: system)
        container.stream.send(message: message)
        
        router.routeDone()
    }
}


