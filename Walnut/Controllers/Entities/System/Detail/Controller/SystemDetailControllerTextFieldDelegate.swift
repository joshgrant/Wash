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
    // MARK: - Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let title = textField.text ?? ""
        
        let message = SystemDetailTitleEditedMessage(title: title)
        AppDelegate.shared.mainStream.send(message: message)
    }
}
