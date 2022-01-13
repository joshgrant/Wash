//
//  EventDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import Foundation
import UIKit

class EventDetailController: ListController<EventDetailSection, EventDetailItem, EventDetailBuilder>
{
    // MARK: - Variables
    
    var router: EventDetailRouter
    
    // MARK: - Initialization
    
    override init(builder: EventDetailBuilder)
    {
        self.router = builder.makeRouter()
        super.init(builder: builder)
        
        title = builder.event.title
        builder.textEditDelegate = self
        builder.toggleDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reload(animated: animated)
    }
}

extension EventDetailController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        title = textField.text
        builder.event.unwrappedName = textField.text
        builder.context.quickSave()
    }
}

extension EventDetailController: ToggleItemDelegate
{
    func toggleDidChangeValue(_ toggle: UISwitch)
    {
        builder.event.isActive = toggle.isOn
    }
}
