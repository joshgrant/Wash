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
    var stream: Stream
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String,
        toggleState: Bool,
        stream: Stream)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
        self.toggleState = toggleState
        self.stream = stream
    }
    
    static var cellClass: AnyClass { ToggleCell.self }
}

class ToggleCell: TableViewCell<ToggleCellModel>
{
    weak var model: ToggleCellModel?
    var selectionIdentifier: SelectionIdentifier?
    
    override func configure(with model: ToggleCellModel)
    {
        self.model = model
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
        model?.stream.send(message: message)
    }
}
