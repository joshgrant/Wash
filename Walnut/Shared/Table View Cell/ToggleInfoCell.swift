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
    override func configure(with model: ToggleCellModel)
    {
        self.textLabel?.text = model.title
        
        let toggle = UISwitch()
        toggle.isOn = model.toggleState
        toggle.addTarget(
            self,
            action: #selector(handleToggle(_:)),
            for: .valueChanged)
        
        self.accessoryView = toggle
    }
    
    @objc func handleToggle(_ sender: UISwitch)
    {
        let message = ToggleCellMessage(state: sender.isOn)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
