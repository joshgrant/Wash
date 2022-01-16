//
//  MinMaxController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit
import Core

protocol MinMaxFactory: Factory
{
    func makeController() -> MinMaxController
    func makeTableView() -> TableView<MinMaxTableViewContainer>
    func makeRightItem(target: MinMaxController) -> UIBarButtonItem
}

class MinMaxContainer: Container
{
    // MARK: - Variables
    
    var model: NewStockModel
    var context: Context
    var stream: Stream
    
    // MARK: - Initialization
    
    init(model: NewStockModel, context: Context, stream: Stream)
    {
        self.model = model
        self.context = context
        self.stream = stream
    }
}

extension MinMaxContainer: MinMaxFactory
{
    func makeController() -> MinMaxController
    {
        .init(container: self)
    }
    
    func makeTableView() -> TableView<MinMaxTableViewContainer>
    {
        let container = MinMaxTableViewContainer(
            newStockModel: model,
            stream: stream,
            style: .grouped)
        return .init(container: container)
    }
    
    // TODO: Use a responder protocol
    func makeRightItem(target: MinMaxController) -> UIBarButtonItem
    {
        let item = UIBarButtonItem(
            title: "Next".localized,
            style: .plain,
            target: target,
            action: #selector(target.nextButtonDidTouchUpInside(_:)))
        item.isEnabled = model.validForMinMax
        return item
    }
}

class MinMaxController: ViewController<MinMaxContainer>
{
    // MARK: - Variables
    
    var id = UUID()
    var tableView: TableView<MinMaxTableViewContainer>
    
    // MARK: - Initialization
    
    required init(container: MinMaxContainer)
    {
        tableView = container.makeTableView()
        super.init(container: container)
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
        
        navigationItem.rightBarButtonItem = container.makeRightItem(target: self)
        
        view.embed(tableView)
    }
    
    // MARK: - Functions
    
    @objc func nextButtonDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        transferCellContentToModels()
        let container = CurrentIdealControllerContainer(
            model: container.model,
            context: container.context,
            stream: container.stream)
        let controller = container.makeController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // FIXME: Also a hack
    func transferModelContentToCells()
    {
        let first = IndexPath(row: 0, section: 0)
        let firstCell = tableView.cellForRow(at: first) as! RightEditCell
        let second = IndexPath(row: 1, section: 0)
        let secondCell = tableView.cellForRow(at: second) as! RightEditCell
        
        var min: String
        var max: String
        
        if container.model.minimum == Double.infinity
        {
            min = "∞"
        }
        else if container.model.minimum == -Double.infinity
        {
            min = "-∞"
        }
        else if let minimum = container.model.minimum
        {
            min = String(format: "%i", Int(minimum))
        }
        else
        {
            min = ""
        }
        
        if container.model.maximum == Double.infinity
        {
            max = "∞"
        }
        else if container.model.maximum == -Double.infinity
        {
            max = "-∞"
        }
        else if let maximum = container.model.maximum
        {
            max = String(format: "%i", Int(maximum))
        }
        else
        {
            max = ""
        }
        
        firstCell.rightField.text = min
        secondCell.rightField.text = max
    }
    
    // FIXME: This is a hack
    func transferCellContentToModels()
    {
        let first = IndexPath(row: 0, section: 0)
        let firstCell = tableView.cellForRow(at: first) as! RightEditCell
        let second = IndexPath(row: 1, section: 0)
        let secondCell = tableView.cellForRow(at: second) as! RightEditCell
        
        container.model.minimum = Double(firstCell.rightField.text ?? "0")
        container.model.maximum = Double(secondCell.rightField.text ?? "0")
        
        // Constraints for the to-be ideal and current
        
        if let current = container.model.currentDouble
        {
            if current >= container.model.maximum!
            {
                container.model.currentDouble = container.model.maximum
            }
            else if current <= container.model.minimum!
            {
                container.model.currentDouble = container.model.minimum
            }
        }
        else
        {
            container.model.currentDouble = container.model.minimum!
        }
        
        if let ideal = container.model.idealDouble
        {
            if ideal >= container.model.maximum!
            {
                container.model.idealDouble = container.model.maximum
            }
            else if ideal <= container.model.minimum!
            {
                container.model.idealDouble = container.model.minimum
            }
        }
        else
        {
            container.model.idealDouble = container.model.minimum!
        }
    }
}

extension MinMaxController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as RightEditCellMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: RightEditCellMessage)
    {
        var value: Double
        
        if message.content == "∞"
        {
            value = Double.infinity
        }
        else if message.content == "-∞"
        {
            value = -Double.infinity
        }
        else
        {
            // TODO: Disallow pasting text into the fields unless it's only numbers...
            value = Double(message.content) ?? 0
        }
        
        switch message.selectionIdentifier
        {
        case .minimum:
            if let max = container.model.maximum, value >= max
            {
                value = max
            }
            
            container.model.minimum = value
            // TODO: set the text on the text field...
        case .maximum:
            if let min = container.model.minimum, value <= min
            {
                value = min
            }
            
            container.model.maximum = value
            // TODO: Set the text on the text field...
        default:
            break
        }
        
        switch message.editType
        {
        case .beginEdit:
            navigationItem.rightBarButtonItem?.isEnabled = false
        case .dismiss:
            transferModelContentToCells()
            navigationItem.rightBarButtonItem?.isEnabled = container.model.validForMinMax
        default:
            break
        }
    }
}
