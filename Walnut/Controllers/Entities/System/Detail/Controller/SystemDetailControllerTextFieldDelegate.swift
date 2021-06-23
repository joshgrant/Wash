//
//  SystemDetailControllerTextFieldDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit

class SystemDetailControllerTextFieldDelegate: NSObject, UITextFieldDelegate
{
    // MARK: - Variables
    
    weak var model: SystemDetailControllerModel?
    weak var controller: SystemDetailController?
    
    // MARK: - Initialization
    
    init(model: SystemDetailControllerModel)
    {
        self.model = model
    }
    
    // MARK: - Functions
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        model?.system.title = textField.text ?? ""
        model?.system.managedObjectContext?.quickSave()
        
        controller?.title = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        NotificationCenter.default.post(name: .titleUpdate, object: nil)
        
        return true
    }
}
