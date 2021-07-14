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
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        toggleState: Bool)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.toggleState = toggleState
    }
    
    static var cellClass: AnyClass { ToggleCell.self }
}

class ToggleCell: TableViewCell<ToggleCellModel>
{
    var selectionIdentifier: SelectionIdentifier?
    
    override func configure(with model: ToggleCellModel)
    {
        self.textLabel?.text = model.title
        self.selectionIdentifier = model.selectionIdentifier
        
        let toggle = UISwitch()
        
        toggle.isOn = model.toggleState
        toggle.addTarget(
            self,
            action: #selector(toggleDidChangeValue(_:)),
            for: .valueChanged)
        
        self.accessoryView = toggle
    }
    
    @objc func toggleDidChangeValue(_ sender: UISwitch)
    {
        guard let identifier = selectionIdentifier else { fatalError() }
        
        let message = ToggleCellMessage(
            state: sender.isOn,
            selectionIdentifier: identifier)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
