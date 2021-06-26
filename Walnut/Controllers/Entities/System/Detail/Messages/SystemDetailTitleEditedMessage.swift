//
//  SystemDetailTitleEditedMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation

class SystemDetailTitleEditedMessage: Message
{
    // MARK: - Variables
    
    var title: String
    
    // MARK: - Initialization
    
    init(title: String)
    {
        self.title = title
    }
}
