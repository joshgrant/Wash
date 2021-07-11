//
//  ToggleCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class ToggleCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    var toggleState: Bool
    var actionClosure: ActionClosure
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        toggleState: Bool)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.toggleState = toggleState
        
        self.actionClosure = ActionClosure { sender in
            guard let sender = sender as? UISwitch else { fatalError() }
            let message = ToggleCellMessage(
                state: sender.isOn,
                selectionIdentifier: .requiresUserCompletion(state: sender.isOn))
            AppDelegate.shared.mainStream.send(message: message)
        }
    }
    
    static var cellClass: AnyClass { ToggleCell.self }
}

class ToggleCell: TableViewCell<ToggleCellModel>
{
    override func configure(with model: ToggleCellModel)
    {
        self.textLabel?.text = model.title
        
        let toggle = UISwitch()
        
        toggle.isOn = model.toggleState
        toggle.addTarget(
            model.actionClosure,
            action: #selector(model.actionClosure.perform(sender:)),
            for: .valueChanged)
        
        self.accessoryView = toggle
    }
}
